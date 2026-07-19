// Copyright 2026 Anachrion
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import '../app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import '../models/profile.dart';
import '../services/api_exception.dart';
import '../services/equipment_service.dart';
import '../services/gang_service.dart';
import '../services/profile_service.dart';
import '../widgets/app_background.dart';
import '../widgets/apprenticeship_dialog.dart';
import '../widgets/equipment_detail.dart';
import '../widgets/faction_badge.dart';
import '../widgets/faction_rule.dart';
import '../widgets/glass_panel.dart';
import '../widgets/guarded_action.dart';
import '../widgets/points_bar.dart';
import '../widgets/profile_search.dart';
import '../widgets/sort_chip.dart';
import '../widgets/spell_chips.dart';
import '../widgets/spell_picker_dialog.dart';
import '../widgets/status_views.dart';
import 'card_viewer_screen.dart';

part 'gang_builder_tiles.dart';

enum _Tab { list, hire }

enum _HireSort { role, name, cost }

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
  bool _busy = false;
  String? _error;
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

  void _recomputeVisibleProfiles() {
    // Runs through the same catalog index the Cards screen searches, so the Hire tab gets free text
    // over abilities/weapons/special rules and ANDed facet chips — not just a name substring. The
    // faction constraint in `searchQuery` reproduces the loaded set, so this never widens the pool
    // beyond what the gang can actually hire.
    final filtered = ProfileService().matching(searchQuery);
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
    _loadData();
  }

  @override
  void dispose() {
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
  /// tab it pops the screen (back to the gangs index). Shared by the header button and, via
  /// [PopScope], the OS back gesture.
  void _handleBack() {
    if (_tab != _Tab.list) {
      _selectTab(_Tab.list);
    } else {
      Navigator.of(context).pop();
    }
  }

  /// Opens the card viewer on [p], then scrolls the hire list so the card the user ended on
  /// (they can swipe up/down to others) is centred, rather than leaving them wherever they were.
  Future<void> _openHireCard(api.Profile p) async {
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
      final results = await Future.wait([
        ProfileService().search('', factions: {_gang.faction, 'gifted'}),
        EquipmentService().getAll(),
        GangService().loadSpells(),
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
        _error = e is ApiException ? e.message : 'Could not reach server';
        _loading = false;
      });
    }
  }

  /// Persists an illustration switch made in the card viewer: repoints the entry at the chosen
  /// sibling card reference and refreshes the gang. The viewer owns the displayed art, so this only
  /// syncs the backend and local state (no _busy gate — it must not block the viewer's own paging).
  Future<void> _onEntryIllustrationChanged(
    api.ListEntry entry,
    int cardReferenceId,
  ) async {
    await guard(context, () async {
      final updated = await GangService().setEntryIllustration(
        entry.id,
        cardReferenceId,
      );
      if (mounted) setState(() => _gang = updated);
    });
  }

  Future<void> _editSpells(api.ListEntry entry) async {
    if (_busy) return;
    final result = await showSpellPickerDialog(
      context,
      entry: entry,
      allSpells: _spells,
      siblingEntries: _gang.entries.toList(),
    );
    if (result == null || !mounted) return;
    setState(() => _busy = true);
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
    if (mounted) setState(() => _busy = false);
  }

  // Apprentice Doctor's Apprenticeship: picks (or clears) the mentor only. Always sends an empty
  // pool_selections — matching what changing/clearing the mentor inside the full spell picker
  // already does — since a new (or no) mentor invalidates whatever Disciplines were mirrored from
  // the old one, there's nothing valid left to preserve.
  Future<void> _editApprenticeship(api.ListEntry entry) async {
    if (_busy) return;
    final result = await showApprenticeshipDialog(
      context,
      entry: entry,
      siblingEntries: _gang.entries.toList(),
    );
    if (result == null || !mounted) return;
    setState(() => _busy = true);
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
    if (mounted) setState(() => _busy = false);
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

  Future<void> _add(api.Profile p) async {
    if (_busy) return;
    final refId = p.cardReferenceId;
    if (refId == null) return; // no printed card → nothing to hire
    setState(() => _busy = true);
    await guard(context, () async {
      final updated = await GangService().addEntry(
        _gang.id,
        refId,
        'CardReference',
      );
      if (!mounted) return;
      setState(() => _gang = updated);
    });
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _addEquipment(api.Equipment e) async {
    if (_busy) return;
    setState(() => _busy = true);
    await guard(context, () async {
      final updated = await GangService().addEntry(_gang.id, e.id, 'Equipment');
      if (!mounted) return;
      setState(() => _gang = updated);
    });
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _remove(api.Profile p) async {
    final entry = _entryFor(p);
    if (entry == null || _busy) return;
    setState(() => _busy = true);
    await guard(context, () async {
      final updated = await GangService().removeEntry(entry.id);
      if (!mounted) return;
      setState(() => _gang = updated);
    });
    if (mounted) setState(() => _busy = false);
  }

  /// Removes a list entry, returning whether it succeeded so the tile can reverse its exit
  /// animation on failure instead of vanishing into a ghost that still counts toward ducats (A-7).
  Future<bool> _removeEntry(api.ListEntry entry) async {
    if (_busy) return false;
    setState(() => _busy = true);
    final ok = await guard(context, () async {
      final updated = await GangService().removeEntry(entry.id);
      if (!mounted) return;
      setState(() => _gang = updated);
    });
    if (mounted) setState(() => _busy = false);
    return ok;
  }

  Future<void> _reorderEntry(int oldIndex, int newIndex) async {
    if (_busy) return;
    if (newIndex > oldIndex) newIndex--;
    if (newIndex == oldIndex) return;
    final entry = _gang.entries[oldIndex];
    final previous = _gang; // snapshot so a failed reorder can be rolled back (A-6)
    final reordered = List<api.ListEntry>.from(_gang.entries)
      ..removeAt(oldIndex)
      ..insert(newIndex, entry);
    setState(() {
      _gang = _gang.rebuild((b) => b..entries.replace(reordered));
      _busy = true;
    });
    final ok = await guard(context, () async {
      final updated = await GangService().reorderEntry(entry.id, newIndex + 1);
      if (!mounted) return;
      setState(() => _gang = updated);
    });
    // The reorder was applied optimistically; if the server rejected it, restore the prior order
    // so the UI doesn't keep showing an order the backend never accepted.
    if (!ok && mounted) setState(() => _gang = previous);
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final factionColor =
        AppPalette.factionColors[_gang.faction] ?? context.accentColor;
    return PopScope(
      // On the Hire tab, swallow the pop and drop back to List instead; on List, let it pop the
      // screen. canPop mirrors this so the OS back gesture is intercepted only when it should be.
      canPop: _tab == _Tab.list,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _tab != _Tab.list) _selectTab(_Tab.list);
      },
      child: Scaffold(
        backgroundColor: AppPalette.background,
        body: AppBackground(
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
          const SizedBox(width: 8),
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

  Widget _buildTabBar(Color factionColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassPanel(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            _TabButton(
              label: 'List',
              selected: _tab == _Tab.list,
              factionColor: factionColor,
              onTap: () => _selectTab(_Tab.list),
            ),
            _TabButton(
              label: 'Hire',
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
      onPageChanged: (i) => setState(() => _tab = _Tab.values[i]),
      children: [_buildListTab(factionColor), _buildHireTab(factionColor)],
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
              'No models hired yet',
              style: GoogleFonts.cinzel(
                fontSize: 15,
                color: context.subtleTextColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Go to Hire to add models',
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
    return ReorderableListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
      onReorder: _reorderEntry,
      proxyDecorator: (child, _, __) => child,
      buildDefaultDragHandles: false,
      itemCount: entries.length,
      itemBuilder: (_, i) {
        final entry = entries[i];
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
        final role = profile == null
            ? null
            : profile.keywords.contains('Leader')
            ? 'leader'
            : profile.keywords.contains('Hero')
            ? 'hero'
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
        // Delayed (long-press) rather than immediate: an immediate listener claims horizontal drags
        // too, which stole the swipe that switches to the Hire tab whenever the list had entries.
        // Long-press-then-drag reorders; a quick horizontal swipe now reaches the tab PageView.
        return ReorderableDelayedDragStartListener(
          key: ValueKey(entry.id),
          index: i,
          child: Padding(
            padding: EdgeInsets.only(bottom: i < entries.length - 1 ? 8 : 0),
            child: _EntryTile(
              entry: entry,
              name: tileName,
              factionColor: entryColor,
              role: role,
              busy: _busy,
              onRemove: () => _removeEntry(entry),
              onTap: onTap,
              onEditSpells: entry.mage ? () => _editSpells(entry) : null,
              onEditApprenticeship: entry.pools.any((p) => p.mentorDerived)
                  ? () => _editApprenticeship(entry)
                  : null,
            ),
          ),
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

    Widget buildTile(api.Profile p) {
      final isUnique = p.keywords.contains('Unique');
      final isLeader = p.keywords.contains('Leader');
      final count = _entryCount(p);
      final alreadyHiredUnique = isUnique && count > 0;
      // Hide "add" for a hard Leader once a hard Leader is already fielded — including this same one,
      // so a non-Unique Leader (King For a Day, Ostrich King?!) can't be hired twice. A flex Leader
      // keeps its button (it will demote), and any Leader stays addable when only a flex Leader is
      // present. The "remove" button is unaffected, so the hired Leader can still be taken back out.
      final leaderSlotTaken = isLeader && !p.flexibleLeader && hasHardLeader;
      return _HireCardTile(
        key: _hireTileKeys.putIfAbsent(p.id, GlobalKey.new),
        profile: p,
        count: count,
        isUnique: isUnique,
        factionColor: factionColor,
        canAdd: !alreadyHiredUnique && !leaderSlotTaken,
        busy: _busy,
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
              'No profiles for this faction.',
              style: TextStyle(color: context.subtleTextColor),
            ),
          )
        : noResults
        ? Center(
            child: Text(
              'Nothing matches your search.',
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
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (_, i) => buildTile(factionProfiles[i]),
                ),
              ),
              if (giftedProfiles.isNotEmpty) ...[
                _buildHireDivider('Mercenaries'),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  sliver: SliverList.separated(
                    itemCount: giftedProfiles.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (_, i) => buildTile(giftedProfiles[i]),
                  ),
                ),
              ],
              if (_visibleEquipment.isNotEmpty) ...[
                _buildHireDivider('Equipment'),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  sliver: SliverList.separated(
                    itemCount: _visibleEquipment.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
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
                        busy: _busy,
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        children: [
          buildSearchField(hintText: 'Search models, equipment, abilities...'),
          if (pickedFacets.isNotEmpty) ...[
            const SizedBox(height: 6),
            Align(alignment: Alignment.centerLeft, child: buildFacetChips()),
          ],
          const SizedBox(height: 6),
          Row(
            children: [
              for (final option in const [
                (label: 'Role', value: _HireSort.role),
                (label: 'Name', value: _HireSort.name),
                (label: 'Cost', value: _HireSort.cost),
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
            ],
          ),
        ],
      ),
    );
  }
}
