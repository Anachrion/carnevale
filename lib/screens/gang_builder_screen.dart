// Carnevale Companion
// Copyright (C) 2026 Anachrion and contributors
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU Affero General Public License as published by the Free
// Software Foundation, either version 3 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
// details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

import 'dart:async';

import '../app_colors.dart';
import '../collection_gate.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import '../l10n/app_localizations.dart';
import '../models/profile.dart';
import '../main.dart';
import '../models/gang_collection_summary.dart';
import '../services/api_exception.dart';
import '../services/equipment_service.dart';
import '../services/gang_service.dart';
import '../services/idempotency.dart';
import '../services/collection_service.dart';
import '../services/profile_service.dart';
import '../services/spell_service.dart';
import '../widgets/app_background.dart';
import '../widgets/app_toast.dart';
import '../widgets/gang_text_dialogs.dart';
import '../widgets/apprenticeship_dialog.dart';
import '../widgets/equipment_detail.dart';
import '../widgets/faction_badge.dart';
import '../widgets/faction_rule.dart';
import '../widgets/glass_panel.dart';
import '../widgets/guarded_action.dart';
import '../widgets/points_bar.dart';
import '../widgets/collection_glyph.dart';
import '../widgets/gang_collection_sheet.dart';
import '../widgets/profile_search.dart';
import '../widgets/sort_chip.dart';
import '../widgets/spell_chips.dart';
import '../widgets/spell_picker_dialog.dart';
import '../widgets/status_views.dart';
import 'card_viewer_screen.dart';

part 'gang_builder_tiles.dart';

enum _Tab { list, hire }

enum _HireSort { role, name, cost }

/// One queued server mutation for the builder's optimistic sync. The UI applies the change to
/// `_gang` immediately and pushes one of these; the queue drains serially in the background so the
/// user never waits on a round-trip. A network blip retries; only a genuine rejection (a server
/// 4xx) reverts the optimistic change and toasts.
class _PendingOp {
  _PendingOp({
    required this.run,
    required this.revert,
    required this.describe,
    this.onCreated,
  });

  /// Fires the server call and returns the authoritative gang. Any temp id it targets is resolved
  /// to the real one at call time — an earlier create in this FIFO queue has already mapped it.
  final Future<api.ModelList> Function() run;

  /// Undoes this op's optimistic change; runs only when the server genuinely rejects the op.
  final VoidCallback revert;

  /// Short label for the failure toast (e.g. "add Bravoes").
  final String describe;

  /// For a create: records the server-assigned id for the temp entry, so a later remove/reorder of
  /// the just-added model can target the real row.
  final void Function(api.ModelList updated)? onCreated;
}

class GangBuilderScreen extends StatefulWidget {
  const GangBuilderScreen({super.key, required this.gang});
  final api.ModelList gang;

  @override
  State<GangBuilderScreen> createState() => _GangBuilderScreenState();
}

class _GangBuilderScreenState extends State<GangBuilderScreen>
    with ProfileSearchMixin {
  late api.ModelList _gang;
  List<api.Profile> _profiles = [];
  List<api.Equipment> _equipment = [];
  List<api.Spell> _spells = [];
  bool _loading = true;
  String? _error;

  // Optimistic sync (F-P5): add/remove/reorder apply to `_gang` at once and push a _PendingOp onto
  // this FIFO queue, which drains one op at a time in the background — the UI never blocks on a
  // round-trip, so there's no spinner storm and no wait. `_syncing` guards single-flight; temp ids
  // (negative, from `_nextTempId`) stand in for optimistically-created rows until the server assigns
  // a real id, recorded in `_idMap` so a later edit of a just-added model can target the real row.
  final List<_PendingOp> _syncQueue = [];
  bool _syncing = false;
  int _nextTempId = -1;
  final Map<int, int> _idMap = {};
  // Guards the dialog-driven edits (spells / apprenticeship / illustration), which replace the whole
  // gang from the server and so must not overlap each other or run mid-sync.
  bool _editing = false;
  _Tab _tab = _Tab.list;
  // Created lazily on first build (after loading), so if the user tapped a tab while the list was
  // still loading, the PageView opens on that tab instead of desyncing from `_tab` (A-10).
  late final _pageController = PageController(initialPage: _tab.index);
  _HireSort _hireSort = _HireSort.role;
  bool _hireSortAsc = true;
  final _hireScroll = ScrollController();

  // One key per hire tile, so a tile can be located and centred after the card viewer closes.
  // Keyed by profile id: the list is rebuilt on search/sort, but a profile keeps its key.
  final Map<int, GlobalKey> _hireTileKeys = {};

  // Cached filtered+sorted hire list. Recomputed only when its inputs (search text, facets, sort
  // field/dir, or the loaded profiles) change — not on every rebuild, which the old getter did
  // (F-P3-6).
  List<api.Profile> _visibleProfiles = [];

  // The Equipment section of the hire tab is searched too — it's hireable from the same list, so a
  // search that ignored it would just make gear look missing.
  List<api.Equipment> _visibleEquipment = [];

  /// You can only ever hire from your own faction plus Gifted (the mercenaries), so unlike the Cards
  /// screen the hire search has no faction picker — it's pinned to exactly what this gang may hire.
  /// This mirrors the `factions:` the profiles were loaded with in [_loadData].
  @override
  Set<String> get searchFactions => {_gang.faction, 'gifted'};

  @override
  void onSearchChanged() {
    _recomputeVisibleProfiles();
    _recomputeVisibleEquipment();
  }

  /// Equipment carries only a name, a description and a cost — no keywords, abilities or weapons —
  /// so free text sweeps its name and description, and a *facet* chip excludes it outright: asking
  /// for "Brave" is a question about models, and no piece of gear can answer it.
  void _recomputeVisibleEquipment() {
    if (pickedFacets.isNotEmpty) {
      _visibleEquipment = const [];
      return;
    }
    final terms = searchController.text
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((term) => term.isNotEmpty);
    _visibleEquipment = _equipment.where((e) {
      final haystack = '${e.name}\n${e.description}'.toLowerCase();
      // Each word must land somewhere, matching how ProfileService sweeps free text.
      return terms.every(haystack.contains);
    }).toList();
  }

  /// The profile behind a transforming model's other printed card (Violent Transformation), looked
  /// up by the card identifier the server sends on the entry. Null for every ordinary model — and
  /// also null if the catalog somehow lacks that card, which just hides the button rather than
  /// breaking the tile. The other form is deliberately searched in the whole loaded set, not the
  /// hireable one: The Beast Within is non-recruitable, so the Hire tab filters it out.
  api.Profile? _otherFormProfile(api.ListEntry entry) {
    final identifier = entry.alternateIdentifier;
    if (identifier == null) return null;

    return _profiles
        .where((p) => p.cardReferences.any((c) => c.identifier == identifier))
        .firstOrNull;
  }

  void _recomputeVisibleProfiles() {
    // Runs through the same catalog index the Cards screen searches, so the Hire tab gets free text
    // over abilities/weapons/special rules and ANDed facet chips — not just a name substring. The
    // faction constraint in `searchQuery` reproduces the loaded set, so this never widens the pool
    // beyond what the gang can actually hire.
    // Drop models that can't be hired directly (the Emissary of Mother Hydra's Tentacles) — they
    // only ever reach a gang automatically, brought in by another model (CARNEVALEB-23). They stay
    // browsable in the Cards catalog; this only hides them from the Hire tab.
    final filtered = ProfileService()
        .matching(searchQuery)
        .where((p) => p.recruitable)
        .toList();
    int roleRank(api.Profile p) {
      if (p.keywords.contains('Leader')) return 0;
      if (p.keywords.contains('Hero')) return 1;
      return 2;
    }

    // Mercenaries always come after the faction's own profiles, whatever the sort
    // and direction. The hire tab renders these as two sections, and the card
    // viewer pages through this same list, so both stay in step.
    int factionRank(api.Profile p) => p.faction == 'gifted' ? 1 : 0;

    filtered.sort((a, b) {
      final factionCmp = factionRank(a).compareTo(factionRank(b));
      if (factionCmp != 0) return factionCmp;

      final asc = _hireSortAsc;
      switch (_hireSort) {
        case _HireSort.cost:
          final c = a.ducats.compareTo(b.ducats);
          return asc ? c : -c;
        case _HireSort.name:
          final c = a.name.compareTo(b.name);
          return asc ? c : -c;
        case _HireSort.role:
          final rankCmp = roleRank(a).compareTo(roleRank(b));
          if (rankCmp != 0) return asc ? rankCmp : -rankCmp;
          final nameCmp = a.name.compareTo(b.name);
          return asc ? nameCmp : -nameCmp;
      }
    });
    _visibleProfiles = filtered;
  }

  @override
  void initState() {
    super.initState();
    _gang = widget.gang;
    // The hire tiles carry the collection mark and the shortfall, and the filter chip reads the
    // same service — redraw whenever it moves (CARNEVALEB-76).
    CollectionService().addListener(_onCollectionChanged);
    // ...and when the account switches the feature on or off, which is what decides
    // whether any of it is drawn at all (CARNEVALEB-76).
    authService.addListener(_onCollectionChanged);
    _loadData();
  }

  void _onCollectionChanged() {
    if (mounted) applySearch();
  }

  @override
  void dispose() {
    CollectionService().removeListener(_onCollectionChanged);
    authService.removeListener(_onCollectionChanged);
    disposeSearch();
    _hireScroll.dispose();
    _pageController.dispose();
    super.dispose();
  }

  /// Switches tabs by driving the [PageView], so a tap animates across just like a swipe does; the
  /// page's onPageChanged is what actually updates [_tab]. Before the list loads the PageView isn't
  /// mounted, so fall back to setting the tab directly.
  void _selectTab(_Tab tab) {
    // While loading, the PageView isn't mounted yet — just record the tab. The PageController is
    // created with `initialPage: _tab.index`, so when the list finishes loading the PageView opens
    // on this tab rather than snapping to page 0 with `_tab` left out of sync (A-10). Guarding on
    // `_loading` also keeps us from touching the lazy controller before that first build.
    if (!_loading && _pageController.hasClients) {
      _pageController.animateToPage(
        tab.index,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
      setState(() => _tab = tab);
    }
  }

  /// Back from the Hire tab returns to the List tab rather than leaving the builder; from the List
  /// tab it pops the screen (back to the gangs index), handing back the current gang so the index can
  /// patch that one row in place instead of refetching every gang. Shared by the header button and,
  /// via [PopScope], the OS back gesture.
  void _handleBack() {
    if (_tab != _Tab.list) {
      _selectTab(_Tab.list);
    } else {
      Navigator.of(context).pop(_gang);
    }
  }

  /// Opens the card viewer on [p], then scrolls the hire list so the card the user ended on
  /// (they can swipe up/down to others) is centred, rather than leaving them wherever they were.
  Future<void> _openHireCard(api.Profile p) async {
    // Tapping a card straight from a focused search field (keyboard up) never goes through the
    // tap-outside dismiss, so the field stays this route's focused child. Drop it now, or popping
    // the viewer would restore focus here and pop the keyboard back up over the hire list.
    searchFocusNode.unfocus();
    final profiles = _visibleProfiles;
    var landedOn = profiles.indexOf(p);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CardViewerScreen(
          profiles: profiles,
          initialIndex: landedOn,
          onIndexChanged: (i) => landedOn = i,
        ),
      ),
    );
    if (!mounted || landedOn < 0 || landedOn >= profiles.length) return;
    await _centreHireTile(profiles[landedOn]);
  }

  /// Centres [p]'s tile in the hire list. If the tile is off-screen it has not been built (the
  /// slivers build lazily), so there is nothing to scroll to: jump to an estimated offset first
  /// to force it into existence, then let ensureVisible place it exactly.
  Future<void> _centreHireTile(api.Profile p) async {
    if (_tab != _Tab.hire || !_hireScroll.hasClients) return;

    var target = _hireTileKeys[p.id]?.currentContext;
    if (target == null) {
      final estimate = _estimatedHireOffset(p);
      if (estimate == null) return;
      _hireScroll.jumpTo(
        estimate.clamp(
          _hireScroll.position.minScrollExtent,
          _hireScroll.position.maxScrollExtent,
        ),
      );
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;
      target = _hireTileKeys[p.id]?.currentContext;
    }
    if (target == null || !target.mounted) return;

    await Scrollable.ensureVisible(
      target,
      alignment: 0.5,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// Rough scroll offset that puts [p]'s tile mid-viewport, measured from a tile that is on
  /// screen (they are all the same height). Only needs to land within a viewport of the target
  /// so that it gets built; ensureVisible corrects the rest, so the divider is approximated.
  double? _estimatedHireOffset(api.Profile p) {
    final index = _visibleProfiles.indexOf(p);
    if (index < 0) return null;

    RenderBox? built;
    for (final key in _hireTileKeys.values) {
      final box = key.currentContext?.findRenderObject() as RenderBox?;
      if (box != null && box.hasSize) {
        built = box;
        break;
      }
    }
    if (built == null) return null;

    const separator = 8.0;
    const dividerEstimate = 60.0;
    final extent = built.size.height + separator;
    final precedingDivider = p.faction == 'gifted' && _gang.faction != 'gifted'
        ? dividerEstimate
        : 0.0;
    final viewport = _hireScroll.position.viewportDimension;
    return (index * extent) +
        precedingDivider -
        (viewport / 2) +
        (built.size.height / 2);
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // The collection only decorates the hire list, so it is fetched alongside and its failures
      // swallowed: an unreachable collection must never keep the builder from opening.
      if (collectionLive) {
        unawaited(CollectionService().load().catchError((_) {}));
      }
      final results = await Future.wait([
        ProfileService().search('', factions: {_gang.faction, 'gifted'}),
        EquipmentService().getAll(),
        SpellService().getAll(),
      ]);
      if (!mounted) return;
      setState(() {
        _profiles = results[0] as List<api.Profile>;
        _equipment = results[1] as List<api.Equipment>;
        _spells = results[2] as List<api.Spell>;
        _loading = false;
        _recomputeVisibleProfiles();
        _recomputeVisibleEquipment();
      });
    } catch (e) {
      // Offline / flaky network: surface a retry instead of spinning forever (C-6).
      if (!mounted) return;
      setState(() {
        _error = e is ApiException ? e.message : AppLocalizations.of(context).errorCouldNotReachServer;
        _loading = false;
      });
    }
  }

  // ── Optimistic sync queue ──────────────────────────────────────────────────────────────────

  int _realId(int id) => _idMap[id] ?? id;

  void _enqueue(_PendingOp op) {
    _syncQueue.add(op);
    _drainQueue();
  }

  Future<void> _drainQueue() async {
    if (_syncing || _syncQueue.isEmpty) return;
    _syncing = true;
    final op = _syncQueue.first;
    try {
      final updated = await op.run();
      _syncQueue.removeAt(0);
      op.onCreated?.call(updated);
      // Adopt the server's authoritative gang only once nothing else is queued — otherwise it would
      // wipe the optimistic entries the still-pending ops just added. Until then the temp entries
      // render fine and `_idMap` keeps later ops pointed at the right rows.
      if (_syncQueue.isEmpty && mounted) setState(() => _gang = updated);
    } on ApiException catch (e) {
      // A DioException with no HTTP response surfaces as statusCode == null: a network blip, not a
      // rejection — keep the op at the head and retry rather than roll the user's change back. Only
      // retry while the screen is open; once it's gone there's no UI to keep consistent, so a failed
      // op is dropped rather than retried forever.
      if (e.statusCode == null && mounted) {
        await Future<void>.delayed(const Duration(seconds: 2));
        _syncing = false;
        _drainQueue();
        return;
      }
      // Genuine rejection (e.g. an entry that no longer exists): drop the op, undo its optimistic
      // change, and say why.
      _syncQueue.removeAt(0);
      if (mounted) {
        op.revert();
        showAppToast(context, e.message);
      }
    } catch (_) {
      // Unexpected: treat like a transient error and retry while open, else drop it.
      if (mounted) {
        await Future<void>.delayed(const Duration(seconds: 2));
        _syncing = false;
        _drainQueue();
        return;
      }
      _syncQueue.removeAt(0);
    }
    _syncing = false;
    // Keep draining even after the screen is gone, so mutations already queued when the user
    // navigated away still reach the server instead of being silently lost (every setState above is
    // mounted-guarded, so this is safe once unmounted).
    _drainQueue();
  }

  /// Waits for the queue to drain, so a dialog-driven edit that replaces the whole gang runs on the
  /// server-authoritative state rather than clobbering entries a pending op just added.
  Future<void> _flushSync() async {
    while (_syncing || _syncQueue.isNotEmpty) {
      await Future<void>.delayed(const Duration(milliseconds: 30));
    }
  }

  // Total ducat cost of the hired (non-summoned) entries — recomputed locally so PointsBar moves the
  // instant a model is added or removed, mirroring the server's own #total_cost.
  int _entriesCost(Iterable<api.ListEntry> entries) =>
      entries.where((e) => !e.summoned).fold(0, (sum, e) => sum + e.cost);

  api.ModelList _gangWith(List<api.ListEntry> entries) => _gang.rebuild(
    (b) => b
      ..entries.replace(entries)
      ..totalCost = _entriesCost(entries),
  );

  // Index of the gang's *effective* Leader — the one entry that keeps the Leader keyword after the
  // server resolves flex-Leader demotion (`demotedLeader`). This is the one pinned to the top; a
  // demoted flex Leader is just a Hero and sits in the reorderable list. Returns -1 when the gang
  // holds no Leader.
  int _effectiveLeaderIndex(List<api.ListEntry> entries) => entries.indexWhere(
    (e) => e.keywords.contains('Leader') && !e.demotedLeader,
  );

  // Whether a freshly-hired entry becomes the gang's effective Leader (and so leads): a hard Leader
  // always does; a flex Leader only when no other Leader is present. Everything else appends in hire
  // order. Mirrors the backend so the optimistic order matches what the server will return.
  bool _leadsGang(api.ListEntry entry, List<api.ListEntry> existing) {
    if (!entry.keywords.contains('Leader')) return false;
    if (!entry.flexibleLeader) return true;
    return !existing.any((e) => e.keywords.contains('Leader'));
  }

  api.ModelList _added(api.ListEntry entry) {
    final entries = _gang.entries.toList();
    if (_leadsGang(entry, entries)) {
      entries.insert(0, entry);
    } else {
      entries.add(entry);
    }
    return _gangWith(entries);
  }

  // Drops the entry and, with it, any companions it brought (an Emissary takes its Tentacles) — so
  // removing a parent clears its companions in the same frame rather than waiting for the server's
  // cascade to come back (CARNEVALEB-23).
  api.ModelList _removed(int id) => _gangWith(
    _gang.entries
        .where((e) => e.id != id && e.companionOfEntryId != id)
        .toList(),
  );

  // The server-created row is the newest (highest id) entry matching what we just added.
  void _mapCreatedId(
    int tempId,
    int entryId,
    api.ListEntryEntryTypeEnum type,
    api.ModelList updated,
  ) {
    final match = updated.entries
        .where((e) => e.entryType == type && e.entryId == entryId)
        .fold<int?>(null, (mx, e) => mx == null || e.id > mx ? e.id : mx);
    if (match != null) _idMap[tempId] = match;
  }

  // A stand-in entry rendered immediately on hire, before the server assigns a real id. Cost,
  // keywords and mage-ness come straight from the profile; the detailed spell `pools` stay empty
  // until the authoritative gang is adopted, which is why the Spells button waits for a real id.
  api.ListEntry _tempCardEntry(api.Profile p, int refId, int tempId) =>
      api.ListEntry(
        (b) => b
          ..id = tempId
          ..position = 0
          ..entryType = api.ListEntryEntryTypeEnum.catalogColonColonCardReference
          ..entryId = refId
          ..name = p.name
          ..keywords = ListBuilder<String>(p.keywords)
          ..flexibleLeader = p.flexibleLeader
          // Demotion is resolved server-side; a freshly-added entry starts undemoted and the
          // authoritative gang (adopted a beat later) fills in the real state.
          ..demotedLeader = false
          ..promotableLeader = false
          ..cost = p.ducats
          ..summoned = false
          // Companion/upgrade state is resolved server-side; a freshly-added model starts with no
          // upgrade and the authoritative gang (adopted a beat later) fills in the real values —
          // including the Emissary's upgrade toggle. companionOfEntryId stays null (nullable).
          ..upgradeSelected = false
          ..upgradeAvailable = false
          ..upgradeDucats = 0
          // Likewise resolved server-side: the pairing that gives a model a second printed card
          // (Violent Transformation) is known only to the server, so the "other form" pill appears
          // a beat later, once the authoritative gang is adopted.
          ..transformable = false
          ..transformed = false
          ..mage = p.mage
          ..distinctDisciplinePerCopy = false
          ..pools = ListBuilder<api.SpellPool>()
          ..grantedSpells = ListBuilder<api.GrantedSpell>(),
      );

  api.ListEntry _tempEquipmentEntry(api.Equipment e, int tempId) => api.ListEntry(
    (b) => b
      ..id = tempId
      ..position = 0
      ..entryType = api.ListEntryEntryTypeEnum.catalogColonColonEquipment
      ..entryId = e.id
      ..name = e.name
      ..keywords = ListBuilder<String>()
      ..flexibleLeader = false
      ..demotedLeader = false
      ..promotableLeader = false
      ..cost = e.cost
      ..summoned = false
      ..upgradeSelected = false
      ..upgradeAvailable = false
      ..upgradeDucats = 0
      // Equipment is never a model, so it never has a second form.
      ..transformable = false
      ..transformed = false
      ..mage = false
      ..distinctDisciplinePerCopy = false
      ..pools = ListBuilder<api.SpellPool>()
      ..grantedSpells = ListBuilder<api.GrantedSpell>(),
  );

  // ── Dialog-driven edits (replace the whole gang; drain the queue first) ──────────────────────

  /// Persists an illustration switch made in the card viewer: repoints the entry at the chosen
  /// sibling card reference and refreshes the gang. The viewer owns the displayed art, so this only
  /// syncs the backend and local state. Drains the optimistic queue first so it applies onto the
  /// server-authoritative gang, not a mid-sync one.
  Future<void> _onEntryIllustrationChanged(
    api.ListEntry entry,
    int cardReferenceId,
  ) async {
    await _flushSync();
    if (!mounted) return;
    await guard(context, () async {
      final updated = await GangService().setEntryIllustration(
        entry.id,
        cardReferenceId,
      );
      if (mounted) setState(() => _gang = updated);
    });
  }

  // Buys or drops the Emissary's optional +12-Ducat upgrade (CARNEVALEB-23). The backend reconciles
  // the auto-included Tentacle entries to match and returns the whole updated gang, so this just
  // swaps it in — like the illustration change, and after the sync queue has drained so it lands on
  // server-authoritative state.
  Future<void> _toggleUpgrade(api.ListEntry entry) async {
    await _flushSync();
    if (!mounted) return;
    await guard(context, () async {
      final updated = await GangService().setEntryUpgrade(
        entry.id,
        !entry.upgradeSelected,
      );
      if (mounted) setState(() => _gang = updated);
    });
  }

  Future<void> _editSpells(api.ListEntry entry) async {
    if (_editing) return;
    final result = await showSpellPickerDialog(
      context,
      entry: entry,
      allSpells: _spells,
      siblingEntries: _gang.entries.toList(),
    );
    if (result == null || !mounted) return;
    _editing = true;
    await _flushSync();
    if (!mounted) return;
    await guard(context, () async {
      final updated = await GangService().setEntrySpells(
        entry.id,
        poolSelections: result.poolSelections,
        mentorChanged: result.mentorChanged,
        mentoredByEntryId: result.mentoredByEntryId,
      );
      if (!mounted) return;
      setState(() => _gang = updated);
    });
    if (mounted) _editing = false;
  }

  // Apprentice Doctor's Apprenticeship: picks (or clears) the mentor only. Always sends an empty
  // pool_selections — matching what changing/clearing the mentor inside the full spell picker
  // already does — since a new (or no) mentor invalidates whatever Disciplines were mirrored from
  // the old one, there's nothing valid left to preserve.
  Future<void> _editApprenticeship(api.ListEntry entry) async {
    if (_editing) return;
    final result = await showApprenticeshipDialog(
      context,
      entry: entry,
      siblingEntries: _gang.entries.toList(),
    );
    if (result == null || !mounted) return;
    _editing = true;
    await _flushSync();
    if (!mounted) return;
    await guard(context, () async {
      final updated = await GangService().setEntrySpells(
        entry.id,
        poolSelections: const [],
        mentorChanged: true,
        mentoredByEntryId: result.mentorEntryId,
      );
      if (!mounted) return;
      setState(() => _gang = updated);
    });
    if (mounted) _editing = false;
  }

  int _entryCount(api.Profile p) => _gang.entries
      .where(
        (e) =>
            e.entryType ==
                api.ListEntryEntryTypeEnum.catalogColonColonCardReference &&
            p.cardReferenceIds.contains(e.entryId),
      )
      .length;

  api.ListEntry? _entryFor(api.Profile p) {
    try {
      return _gang.entries.firstWhere(
        (e) =>
            e.entryType ==
                api.ListEntryEntryTypeEnum.catalogColonColonCardReference &&
            p.cardReferenceIds.contains(e.entryId),
      );
    } catch (_) {
      return null;
    }
  }

  void _add(api.Profile p) {
    final refId = p.cardReferenceId;
    if (refId == null) return; // no printed card → nothing to hire
    final tempId = _nextTempId--;
    // One key per op, reused across the queue's retries so a lost hire replays instead of duplicating.
    final key = newIdempotencyKey();
    setState(() => _gang = _added(_tempCardEntry(p, refId, tempId)));
    _enqueue(
      _PendingOp(
        describe: 'add ${p.name}',
        run: () =>
            GangService().addEntry(_gang.id, refId, 'CardReference', requestKey: key),
        onCreated: (u) => _mapCreatedId(
          tempId,
          refId,
          api.ListEntryEntryTypeEnum.catalogColonColonCardReference,
          u,
        ),
        revert: () => setState(() => _gang = _removed(_realId(tempId))),
      ),
    );
  }

  void _addEquipment(api.Equipment e) {
    final tempId = _nextTempId--;
    final key = newIdempotencyKey();
    setState(() => _gang = _added(_tempEquipmentEntry(e, tempId)));
    _enqueue(
      _PendingOp(
        describe: 'add ${e.name}',
        run: () =>
            GangService().addEntry(_gang.id, e.id, 'Equipment', requestKey: key),
        onCreated: (u) => _mapCreatedId(
          tempId,
          e.id,
          api.ListEntryEntryTypeEnum.catalogColonColonEquipment,
          u,
        ),
        revert: () => setState(() => _gang = _removed(_realId(tempId))),
      ),
    );
  }

  void _remove(api.Profile p) {
    final entry = _entryFor(p);
    if (entry != null) _removeEntry(entry);
  }

  /// Removes a list entry optimistically: it's dropped from `_gang` at once and the delete syncs in
  /// the background. A genuine rejection re-inserts it (and toasts); the Leader-first order and cost
  /// self-correct when the authoritative gang is next adopted.
  void _removeEntry(api.ListEntry entry) {
    // Snapshot the whole gang so a genuine rejection restores it exactly — including any companions
    // that were cascaded out alongside this entry (see _removed).
    final previous = _gang.entries.toList();
    setState(() => _gang = _removed(entry.id));
    _enqueue(
      _PendingOp(
        describe: 'remove ${entry.name}',
        run: () => GangService().removeEntry(_realId(entry.id)),
        revert: () => setState(() => _gang = _gangWith(previous)),
      ),
    );
  }

  void _reorderEntry(int oldIndex, int newIndex) {
    // onReorderItem already adjusts newIndex for the removed item at oldIndex.
    if (newIndex == oldIndex) return;
    // The drag indices count the non-leader models only (the Leader is a pinned header, not part of
    // the reorderable list). Rebuild that sub-order, keep the Leader — if any — at the top, and
    // translate the target back into a full-list position for the backend (the Leader holds
    // position 1, so a non-leader's first slot is position 2).
    final rest = _gang.entries.toList();
    final leaderIndex = _effectiveLeaderIndex(rest);
    final leader = leaderIndex >= 0 ? rest.removeAt(leaderIndex) : null;
    final entry = rest.removeAt(oldIndex);
    rest.insert(newIndex, entry);
    final reordered = [?leader, ...rest];
    final position = (leader != null ? 1 : 0) + newIndex + 1;
    final previous = _gang.entries.toList(); // restore this order on a genuine rejection
    setState(() => _gang = _gangWith(reordered));
    _enqueue(
      _PendingOp(
        describe: 'reorder ${entry.name}',
        run: () => GangService().reorderEntry(_realId(entry.id), position),
        revert: () => setState(() => _gang = _gangWith(previous)),
      ),
    );
  }

  // Promotes a demoted flex Leader (The Duke / Prince of Thieves in the ambiguous case) to the top,
  // making it the effective Leader and demoting the one that held the slot. Optimistically swaps the
  // demotion flags and moves it up; the server confirms on adopt. Reuses the reorder endpoint — the
  // backend lets a promotable entry take position 1.
  void _promote(api.ListEntry entry) {
    final previous = _gang.entries.toList();
    final oldLeaderId = previous
        .firstWhere(
          (e) => e.keywords.contains('Leader') && !e.demotedLeader,
          orElse: () => entry,
        )
        .id;
    final swapped = previous.map((e) {
      if (e.id == entry.id) {
        return e.rebuild((b) => b
          ..demotedLeader = false
          ..promotableLeader = false);
      }
      if (e.id == oldLeaderId) {
        return e.rebuild((b) => b
          ..demotedLeader = true
          ..promotableLeader = true);
      }
      return e;
    }).toList();
    final promoted = swapped.firstWhere((e) => e.id == entry.id);
    swapped
      ..remove(promoted)
      ..insert(0, promoted);
    setState(() => _gang = _gangWith(swapped));
    _enqueue(
      _PendingOp(
        describe: 'promote ${entry.name}',
        run: () => GangService().reorderEntry(_realId(entry.id), 1),
        revert: () => setState(() => _gang = _gangWith(previous)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final factionColor =
        AppPalette.factionColors[_gang.faction] ?? context.accentColor;
    return PopScope(
      // Always intercept the gesture so we pop manually and can hand the current gang back to the
      // index: on the Hire tab drop to List instead of leaving; on List, pop with `_gang` (via
      // _handleBack) so the index patches that row rather than refetching every gang.
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _handleBack();
      },
      child: Scaffold(
        backgroundColor: AppPalette.background,
        // Tapping anywhere in the body that isn't itself a focusable/tappable control (including
        // the header, points bar and tab bar above the search field) drops keyboard focus,
        // hiding the suggestions panel with it — a real tap directly on the search field or any
        // other control still wins its own gesture, so this doesn't interfere with typing or
        // normal navigation. Tapping back into the field brings both straight back.
        body: dismissSearchFocusOnTapOutside(
          child: AppBackground(
            child: Column(
              children: [
                _buildHeader(context, factionColor),
                PointsBar(
                  used: _gang.totalCost,
                  limit: _gang.points,
                  factionColor: factionColor,
                  editable: true,
                ),
                if (_gang.entries.isNotEmpty && !_gang.selectionValid)
                  _buildValidityPanel(),
                const SizedBox(height: 12),
                _buildTabBar(factionColor),
                const SizedBox(height: 8),
                Expanded(child: _buildTabContent(factionColor)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color factionColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: context.textColor),
            onPressed: _handleBack,
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              _gang.name ?? '',
              style: GoogleFonts.cinzel(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: context.textColor,
                letterSpacing: 2,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          // Whether this gang can actually be put on the table with what the player owns
          // (CARNEVALEB-76). Gang-level like the export beside it, so it keeps the same company.
          if (collectionLive) _buildCollectionButton(),
          // Hands this gang over as plain text (CARNEVALEB-74) — the one action that belongs to the
          // gang as a whole rather than to a model, so it sits with the title rather than in the list.
          IconButton(
            icon: Icon(Icons.ios_share, color: context.accentColor, size: 20),
            tooltip: AppLocalizations.of(context).gangExportTitle,
            onPressed: () => showGangExportDialog(context, _gang.id),
          ),
          const SizedBox(width: 4),
          // The faction emblem doubles as the way into the faction's Command Ability — tap it to
          // read the rule. Only made tappable when we have that faction's rule on file.
          if (factionSpecialRules.containsKey(_gang.faction))
            GestureDetector(
              onTap: () => showFactionRuleDialog(context, _gang.faction),
              behavior: HitTestBehavior.opaque,
              child: FactionBadge(
                faction: _gang.faction,
                color: factionColor,
                size: 38,
              ),
            )
          else
            FactionBadge(faction: _gang.faction, color: factionColor, size: 38),
        ],
      ),
    );
  }

  TextSpan _highlightNumbers(String text, TextStyle base) {
    final spans = <InlineSpan>[];
    final re = RegExp(r'\d+');
    int last = 0;
    for (final m in re.allMatches(text)) {
      if (m.start > last) {
        spans.add(TextSpan(text: text.substring(last, m.start), style: base));
      }
      spans.add(
        TextSpan(
          text: m.group(0),
          style: base.copyWith(fontWeight: FontWeight.w700),
        ),
      );
      last = m.end;
    }
    if (last < text.length) {
      spans.add(TextSpan(text: text.substring(last), style: base));
    }
    return TextSpan(children: spans);
  }

  Widget _buildValidityPanel() {
    final errors = _gang.selectionErrors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppPalette.brightRed,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: errors.map((e) {
            final base = TextStyle(
              fontSize: 12,
              color: Colors.white,
              height: 1.4,
            );
            return Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(child: RichText(text: _highlightNumbers(e, base))),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// The way into the gang's collection summary, with a quiet red dot when something is missing.
  ///
  /// The dot is the whole point of putting it here rather than inside the sheet: the answer you
  /// want at a glance while building is "is anything short?", and the detail is one tap away.
  Widget _buildCollectionButton() {
    final summary = GangCollectionSummary.of(
      entries: _gang.entries,
      profiles: _profiles,
    );
    return IconButton(
      tooltip: AppLocalizations.of(context).collectionGangTitle,
      onPressed: () => showGangCollectionSheet(
        context,
        entries: _gang.entries,
        profiles: _profiles,
      ),
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          CollectionGlyph.mark(color: context.accentColor, size: 20),
          if (!summary.isComplete)
            Positioned(
              top: -2,
              right: -3,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.dangerColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabBar(Color factionColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassPanel(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            _TabButton(
              label: AppLocalizations.of(context).gangTabList,
              selected: _tab == _Tab.list,
              factionColor: factionColor,
              onTap: () => _selectTab(_Tab.list),
            ),
            _TabButton(
              label: AppLocalizations.of(context).gangTabHire,
              selected: _tab == _Tab.hire,
              factionColor: factionColor,
              onTap: () => _selectTab(_Tab.hire),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(Color factionColor) {
    if (_loading) {
      return Center(
        child: CircularProgressIndicator(color: context.accentColor),
      );
    }
    if (_error != null) {
      return ErrorRetryView(message: _error!, onRetry: _loadData);
    }
    // A PageView so List and Hire can be swiped between, not just tapped. onPageChanged is the single
    // source of truth for [_tab] — both a swipe and a tab-bar tap (which animates the page) land
    // here. Order must match _Tab: index 0 = list, 1 = hire.
    return PageView(
      controller: _pageController,
      onPageChanged: (i) {
        // Leaving the Hire tab shouldn't strand its search keyboard over the List tab. No-op the
        // other way round, since only Hire has a search field.
        searchFocusNode.unfocus();
        setState(() => _tab = _Tab.values[i]);
      },
      children: [
        _KeepAlivePage(child: _buildListTab(factionColor)),
        _KeepAlivePage(child: _buildHireTab(factionColor)),
      ],
    );
  }

  Widget _buildListTab(Color factionColor) {
    final entries = _gang.entries;
    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.group_outlined,
              size: 48,
              color: context.subtleTextColor.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context).gangBuilderNoModels,
              style: GoogleFonts.cinzel(
                fontSize: 15,
                color: context.subtleTextColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              AppLocalizations.of(context).gangGoToHire,
              style: TextStyle(
                fontSize: 12,
                color: context.subtleTextColor.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }
    // The hired card-reference entries paired with their profile, in list order. The card viewer
    // pages through these; it needs the entry behind each card so switching a card's illustration
    // can repoint that exact entry (and persist it).
    final hiredCards = entries
        .where(
          (e) =>
              e.entryType ==
              api.ListEntryEntryTypeEnum.catalogColonColonCardReference,
        )
        .map((e) {
          final p = _profiles
              .where((pp) => pp.cardReferenceIds.contains(e.entryId))
              .firstOrNull;
          return p == null ? null : (entry: e, profile: p);
        })
        .whereType<({api.ListEntry entry, api.Profile profile})>()
        .toList();
    final hiredProfiles = hiredCards.map((c) => c.profile).toList();
    // Display names, keyed by entry id: use the profile name (dropping the card-reference letter),
    // and when the same profile is hired more than once, number the copies in list order —
    // "Common Strigoi 1", "Common Strigoi 2". A profile hired once keeps its plain name.
    final profileCounts = <int, int>{};
    for (final c in hiredCards) {
      profileCounts[c.profile.id] = (profileCounts[c.profile.id] ?? 0) + 1;
    }
    final profileSeen = <int, int>{};
    final entryDisplayName = <int, String>{};
    for (final c in hiredCards) {
      if ((profileCounts[c.profile.id] ?? 0) > 1) {
        final n = (profileSeen[c.profile.id] ?? 0) + 1;
        profileSeen[c.profile.id] = n;
        entryDisplayName[c.entry.id] = '${c.profile.name} $n';
      } else {
        entryDisplayName[c.entry.id] = c.profile.name;
      }
    }
    // Builds one hired-entry tile. Shared by the pinned Leader header and the reorderable body so
    // both render identically. `last` drops the trailing gap on the final visible tile.
    Widget buildEntryTile(api.ListEntry entry, {required bool last}) {
      final profileIdx =
          entry.entryType ==
              api.ListEntryEntryTypeEnum.catalogColonColonCardReference
          ? _profiles.indexWhere(
              (p) => p.cardReferenceIds.contains(entry.entryId),
            )
          : -1;
      final profile = profileIdx != -1 ? _profiles[profileIdx] : null;
      final equipmentItem =
          entry.entryType ==
              api.ListEntryEntryTypeEnum.catalogColonColonEquipment
          ? _equipment.where((e) => e.id == entry.entryId).firstOrNull
          : null;
      final entryColor =
          entry.entryType ==
              api.ListEntryEntryTypeEnum.catalogColonColonEquipment
          ? AppPalette.equipment
          : profile?.faction == 'gifted'
          ? (AppPalette.factionColors['gifted'] ?? factionColor)
          : factionColor;
      // A demoted flex Leader has lost the Leader keyword, so it reads as a Hero even though its
      // profile still prints Leader.
      final role = entry.demotedLeader
          ? AppLocalizations.of(context).gangRoleHero
          : entry.keywords.contains('Leader')
          ? AppLocalizations.of(context).gangRoleLeader
          : entry.keywords.contains('Hero')
          ? AppLocalizations.of(context).gangRoleHero
          : null;
      VoidCallback? onTap;
      if (profile != null) {
        // Open on this exact entry (matched by entry id, so two copies of one profile that were
        // hired with different illustrations open on their own card, not the first occurrence).
        final hiredIndex = hiredCards.indexWhere((c) => c.entry.id == entry.id);
        onTap = () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CardViewerScreen(
              profiles: hiredProfiles,
              initialIndex: hiredIndex < 0 ? 0 : hiredIndex,
              // Each card opens on the illustration its entry was hired as; switching in the
              // viewer repoints that entry and persists it.
              selectedReferenceIds: hiredCards
                  .map((c) => c.entry.entryId)
                  .toList(),
              onIllustrationChanged: (index, refId) =>
                  _onEntryIllustrationChanged(hiredCards[index].entry, refId),
            ),
          ),
        );
      } else if (equipmentItem != null) {
        onTap = () => showEquipmentDetailDialog(context, equipmentItem);
      }
      final tileName = profile != null
          ? (entryDisplayName[entry.id] ?? profile.name)
          : (equipmentItem?.name ?? entry.name);
      // Violent Transformation: the profile behind this model's other printed card, if it has one.
      final otherForm = _otherFormProfile(entry);
      return Padding(
        padding: EdgeInsets.only(bottom: last ? 0 : 8),
        child: _EntryTile(
          entry: entry,
          name: tileName,
          factionColor: entryColor,
          role: role,
          onRemove: () => _removeEntry(entry),
          // A companion (a Tentacle) is read-only — it leaves only with the model that brought it.
          isCompanion: entry.companionOfEntryId != null,
          // A model that offers an optional paid upgrade (the Emissary) gets a toggle; guard on a real
          // id so a just-hired model syncs before the toggle can fire.
          onToggleUpgrade: entry.upgradeAvailable && entry.id > 0
              ? () => _toggleUpgrade(entry)
              : null,
          onTap: onTap,
          // Spell/mentor edits need the server-side pool detail, which only lands once the entry has
          // a real id (a just-added model syncs a beat later); guard on that so the buttons don't
          // open a picker with nothing in it.
          onEditSpells: entry.mage && entry.id > 0
              ? () => _editSpells(entry)
              : null,
          onEditApprenticeship:
              entry.id > 0 && entry.pools.any((p) => p.mentorDerived)
              ? () => _editApprenticeship(entry)
              : null,
          // A demoted flex Leader the player may crown instead (ambiguous multi-flex case).
          onPromote: entry.promotableLeader && entry.id > 0
              ? () => _promote(entry)
              : null,
          // Violent Transformation: opens the model's other card. Read-only — the gang holds the
          // model as hired and its ducats never move, because the rule transforms it in play, not
          // at hiring. The swap itself lives in the game screen.
          onPreviewOtherForm: otherForm != null
              ? () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CardViewerScreen(
                      profiles: [otherForm],
                      initialIndex: 0,
                    ),
                  ),
                )
              : null,
        ),
      );
    }

    // The Leader is pinned to the top as a non-reorderable header; only the other models sit in the
    // reorderable list. Keeping the Leader out of the reorderable area entirely means nothing can be
    // dragged above it at all — there's no illegal drop to clamp or roll back.
    final leaderIndex = _effectiveLeaderIndex(entries.toList());
    final leaderEntry = leaderIndex >= 0 ? entries[leaderIndex] : null;
    final reorderable = [
      for (final e in entries)
        if (e.id != leaderEntry?.id) e,
    ];

    return ReorderableListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
      header: leaderEntry == null
          ? null
          : buildEntryTile(leaderEntry, last: reorderable.isEmpty),
      onReorderItem: _reorderEntry,
      proxyDecorator: (child, _, _) => child,
      buildDefaultDragHandles: false,
      itemCount: reorderable.length,
      itemBuilder: (_, i) {
        final entry = reorderable[i];
        // Delayed (long-press) rather than immediate: an immediate listener claims horizontal drags
        // too, which stole the swipe that switches to the Hire tab whenever the list had entries.
        // Long-press-then-drag reorders; a quick horizontal swipe now reaches the tab PageView.
        // Companions (Tentacles) are draggable like any other model — they just can't be removed on
        // their own (see _EntryTile.isCompanion).
        return ReorderableDelayedDragStartListener(
          key: ValueKey(entry.id),
          index: i,
          child: buildEntryTile(entry, last: i == reorderable.length - 1),
        );
      },
    );
  }

  Widget _buildHireTab(Color factionColor) {
    final profiles = _visibleProfiles;

    final factionProfiles = _gang.faction == 'gifted'
        ? profiles
        : profiles.where((p) => p.faction == _gang.faction).toList();
    final giftedProfiles = _gang.faction == 'gifted'
        ? <api.Profile>[]
        : profiles.where((p) => p.faction == 'gifted').toList();

    // Only a "hard" Leader locks out other Leaders. A flex Leader (The Duke, Prince of Thieves,
    // Sopracomito, La Signora) demotes to a plain Hero when another Leader is present, so it neither
    // occupies the slot immovably nor blocks a real Leader from being added alongside it.
    final hasHardLeader = _profiles.any(
      (p) => p.keywords.contains('Leader') && !p.flexibleLeader && _entryCount(p) > 0,
    );
    // A *conditional* flex Leader (La Signora) currently leading: she's in the gang, but the specific
    // partner she demotes alongside (Il Capitano) isn't, so she keeps the Leader keyword. While she
    // leads, the only hard Leader still recruitable is that partner — any other would leave two
    // Leaders. `flexibleLeaderWith` is that partner's profile id; null for the demote-alongside-any
    // flex Leaders and hard Leaders.
    int? leadingConditionalPartnerId;
    for (final p in _profiles) {
      if (p.keywords.contains('Leader') &&
          p.flexibleLeader &&
          p.flexibleLeaderWith != null &&
          _entryCount(p) > 0 &&
          !_profiles.any(
            (q) => q.id == p.flexibleLeaderWith && _entryCount(q) > 0,
          )) {
        leadingConditionalPartnerId = p.flexibleLeaderWith;
        break;
      }
    }

    Widget buildTile(api.Profile p) {
      final isUnique = p.keywords.contains('Unique');
      final isLeader = p.keywords.contains('Leader');
      final count = _entryCount(p);
      final alreadyHiredUnique = isUnique && count > 0;
      // Hide "add" for a hard Leader once a hard Leader is already fielded — including this same one,
      // so a non-Unique Leader (King For a Day, Ostrich King?!) can't be hired twice. A flex Leader
      // keeps its button (it will demote), and any Leader stays addable when only a flex Leader is
      // present. And while a conditional flex Leader leads, only her partner may be added among hard
      // Leaders. The "remove" button is unaffected, so the hired Leader can still be taken back out.
      final hardLeaderTaken = isLeader &&
          !p.flexibleLeader &&
          (hasHardLeader ||
              (leadingConditionalPartnerId != null &&
                  p.id != leadingConditionalPartnerId));
      // A conditional flex Leader (La Signora) can't join a gang that already holds a hard Leader who
      // isn't her partner — she wouldn't demote for him, leaving two Leaders.
      final conditionalFlexBlocked =
          isLeader &&
          p.flexibleLeader &&
          p.flexibleLeaderWith != null &&
          _profiles.any(
            (q) =>
                q.keywords.contains('Leader') &&
                !q.flexibleLeader &&
                q.id != p.flexibleLeaderWith &&
                _entryCount(q) > 0,
          );
      final leaderSlotTaken = hardLeaderTaken || conditionalFlexBlocked;
      final collected = collectionLive
          ? CollectionService().entryFor(p.id)
          : CollectionEntry.none;
      return _HireCardTile(
        key: _hireTileKeys.putIfAbsent(p.id, GlobalKey.new),
        profile: p,
        count: count,
        isUnique: isUnique,
        owned: collected.owned,
        factionColor: factionColor,
        canAdd: !alreadyHiredUnique && !leaderSlotTaken,
        busy: false,
        onOpen: () => _openHireCard(p),
        onAdd: () => _add(p),
        onRemove: () => _remove(p),
      );
    }

    return Column(
      children: [
        _buildHireControls(),
        // The suggestions float over the hire list rather than sitting in the column, so opening
        // them doesn't shove the list down. Same arrangement as the Cards screen.
        Expanded(
          child: Stack(
            children: [
              _buildHireList(factionProfiles, giftedProfiles, buildTile),
              if (hasSuggestions)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: buildSuggestions(),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHireList(
    List<api.Profile> factionProfiles,
    List<api.Profile> giftedProfiles,
    Widget Function(api.Profile) buildTile,
  ) {
    // Gated on *both* sections being empty, not just the profiles: a search like "gondola" matches
    // no model but does match a piece of gear, and keying the empty state off the profiles alone
    // used to replace the whole list — equipment included — with "nothing found".
    final noResults = _visibleProfiles.isEmpty && _visibleEquipment.isEmpty;
    return _profiles.isEmpty
        ? Center(
            child: Text(
              AppLocalizations.of(context).gangNoProfilesForFaction,
              style: TextStyle(color: context.subtleTextColor),
            ),
          )
        : noResults
        ? Center(
            child: Text(
              AppLocalizations.of(context).gangNothingMatches,
              style: TextStyle(color: context.subtleTextColor),
            ),
          )
        : CustomScrollView(
            controller: _hireScroll,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                sliver: SliverList.separated(
                  itemCount: factionProfiles.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (_, i) => buildTile(factionProfiles[i]),
                ),
              ),
              if (giftedProfiles.isNotEmpty) ...[
                _buildHireDivider(AppLocalizations.of(context).gangSectionMercenaries),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  sliver: SliverList.separated(
                    itemCount: giftedProfiles.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (_, i) => buildTile(giftedProfiles[i]),
                  ),
                ),
              ],
              if (_visibleEquipment.isNotEmpty) ...[
                _buildHireDivider(AppLocalizations.of(context).gangSectionEquipment),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  sliver: SliverList.separated(
                    itemCount: _visibleEquipment.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      final e = _visibleEquipment[i];
                      final count = _gang.entries
                          .where(
                            (en) =>
                                en.entryType ==
                                    api
                                        .ListEntryEntryTypeEnum
                                        .catalogColonColonEquipment &&
                                en.entryId == e.id,
                          )
                          .length;
                      final canAdd = count == 0;
                      return _HireEquipmentTile(
                        equipment: e,
                        count: count,
                        canAdd: canAdd,
                        busy: false,
                        onAdd: () => _addEquipment(e),
                        onTap: () => showEquipmentDetailDialog(context, e),
                      );
                    },
                  ),
                ),
              ] else
                const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
            ],
          );
  }

  SliverToBoxAdapter _buildHireDivider(String label) => SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: context.subtleTextColor.withValues(alpha: 0.3),
              thickness: 0.5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                color: context.subtleTextColor.withValues(alpha: 0.7),
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: context.subtleTextColor.withValues(alpha: 0.3),
              thickness: 0.5,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildHireControls() {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        children: [
          buildSearchField(hintText: l10n.gangSearchHint),
          if (pickedFacets.isNotEmpty) ...[
            const SizedBox(height: 6),
            Align(alignment: Alignment.centerLeft, child: buildFacetChips()),
          ],
          const SizedBox(height: 6),
          Row(
            children: [
              for (final option in [
                (label: l10n.sortRole, value: _HireSort.role),
                (label: l10n.sortName, value: _HireSort.name),
                (label: l10n.sortCost, value: _HireSort.cost),
              ]) ...[
                if (option.value != _HireSort.role) const SizedBox(width: 6),
                SortChip(
                  label: option.label,
                  selected: _hireSort == option.value,
                  ascending: _hireSortAsc,
                  onTap: () => setState(() {
                    final (field, asc) = applySortTap(
                      option.value,
                      _hireSort,
                      _hireSortAsc,
                    );
                    _hireSort = field;
                    _hireSortAsc = asc;
                    _recomputeVisibleProfiles();
                  }),
                ),
              ],
              // Filters rather than sorts, so it sits at the opposite edge (same as Cards).
              const Spacer(),
              buildCollectionChip(),
            ],
          ),
        ],
      ),
    );
  }
}
