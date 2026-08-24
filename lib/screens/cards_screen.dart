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
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../services/api_exception.dart';
import '../services/collection_service.dart';
import '../services/profile_service.dart';
import '../widgets/collection_glyph.dart';
import '../widgets/faction_filter_row.dart';
import '../widgets/app_background.dart';
import '../widgets/app_drawer.dart';
import '../widgets/profile_search.dart';
import '../widgets/screen_header.dart';
import '../widgets/sort_chip.dart';
import '../widgets/status_views.dart';
import 'card_viewer_screen.dart';

enum _CardSort { role, name, cost }

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> with ProfileSearchMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _service = ProfileService();

  List<api.Profile> _results = [];
  // Cached sorted view of _results; recomputed only when the results or sort change (F-P3-6).
  List<api.Profile> _sorted = [];
  final Set<String> _selectedFactions = {};
  bool _loading = true;
  String? _error;
  _CardSort _sort = _CardSort.name;
  bool _sortAsc = true;

  /// The Cards screen searches the whole catalog, narrowed to whichever factions are picked.
  @override
  Set<String> get searchFactions => _selectedFactions;

  @override
  void onSearchChanged() {
    _results = _service.matching(searchQuery);
    _recomputeSorted();
  }

  // Leaders first, then Heroes, then everyone else — the same ranking the Hire tab sorts by, so
  // "Role" means the same thing on both screens.
  static int _roleRank(api.Profile p) {
    if (p.keywords.contains('Leader')) return 0;
    if (p.keywords.contains('Hero')) return 1;
    return 2;
  }

  void _recomputeSorted() {
    final list = List<api.Profile>.from(_results);
    list.sort((a, b) {
      switch (_sort) {
        case _CardSort.cost:
          final c = a.ducats.compareTo(b.ducats);
          return _sortAsc ? c : -c;
        case _CardSort.name:
          final c = a.name.compareTo(b.name);
          return _sortAsc ? c : -c;
        case _CardSort.role:
          final rankCmp = _roleRank(a).compareTo(_roleRank(b));
          if (rankCmp != 0) return _sortAsc ? rankCmp : -rankCmp;
          // Ties (same role) fall back to name, so each role band reads alphabetically.
          final nameCmp = a.name.compareTo(b.name);
          return _sortAsc ? nameCmp : -nameCmp;
      }
    });
    _sorted = list;
  }

  @override
  void initState() {
    super.initState();
    // The badges and the "my collection" chip both read the service, so redraw when it moves —
    // a stepper tapped in the card viewer should be visible on this list when it pops back.
    CollectionService().addListener(_onCollectionChanged);
    // ...and when the account switches the feature on or off, which is what decides
    // whether any of it is drawn at all (CARNEVALEB-76).
    authService.addListener(_onCollectionChanged);
    _load();
  }

  @override
  void dispose() {
    CollectionService().removeListener(_onCollectionChanged);
    authService.removeListener(_onCollectionChanged);
    disposeSearch();
    super.dispose();
  }

  void _onCollectionChanged() {
    if (mounted) applySearch();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await _service.loadAll();
      // The collection is decoration on this screen, not its subject: a failure to fetch it must
      // never keep the catalog from showing, so it is loaded alongside and its errors swallowed.
      if (collectionLive) {
        unawaited(CollectionService().load().catchError((_) {}));
      }
      if (!mounted) return;
      setState(() => _loading = false);
      applySearch();
    } catch (e) {
      // The catalog isn't persisted, so an offline first launch has nothing to show — offer a
      // retry instead of spinning forever with an unhandled exception (C-6).
      if (!mounted) return;
      setState(() {
        _error = e is ApiException ? e.message : AppLocalizations.of(context).errorCouldNotReachServer;
        _loading = false;
      });
    }
  }

  void _toggleFaction(String faction) {
    if (!_selectedFactions.remove(faction)) _selectedFactions.add(faction);
    applySearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppPalette.background,
      drawer: const AppDrawer(current: AppDrawerRoute.cards),
      // Tapping anywhere in the body that isn't itself a focusable/tappable control (including
      // the header and the margins around the search field) drops keyboard focus, hiding the
      // suggestions panel with it — a real tap directly on the search field or any other control
      // still wins its own gesture, so this doesn't interfere with typing or navigation. Tapping
      // back into the field brings both straight back.
      body: dismissSearchFocusOnTapOutside(
        child: AppBackground(
          child: Column(
            children: [
              _buildHeader(context),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: buildSearchField(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: buildFacetChips(),
              ),
              // The suggestions float over the filters and the card list rather than sitting in
              // the column, so opening them doesn't shove the page down. Stacking them inside the
              // area below the search box (not over the whole screen) keeps them hit-testable,
              // and lets the panel's backdrop filter blur the cards showing through it.
              Expanded(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        FactionFilterRow(
                          selected: _selectedFactions,
                          onToggle: _toggleFaction,
                        ),
                        _buildSortChips(),
                        const SizedBox(height: 8),
                        Expanded(child: _buildList()),
                      ],
                    ),
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
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return ScreenHeader(
      title: AppLocalizations.of(context).navCards,
      onMenu: () => _scaffoldKey.currentState?.openDrawer(),
      trailing: Text(
        AppLocalizations.of(context).cardsProfileCount(_results.length),
        style: TextStyle(fontSize: 12, color: context.subtleTextColor),
      ),
    );
  }

  Widget _buildSortChips() {
    final l10n = AppLocalizations.of(context);
    Widget chip(String label, _CardSort value) => SortChip(
      label: label,
      selected: _sort == value,
      ascending: _sortAsc,
      onTap: () => setState(() {
        final (field, asc) = applySortTap(value, _sort, _sortAsc);
        _sort = field;
        _sortAsc = asc;
        _recomputeSorted();
      }),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          chip(l10n.sortRole, _CardSort.role),
          const SizedBox(width: 6),
          chip(l10n.sortName, _CardSort.name),
          const SizedBox(width: 6),
          chip(l10n.sortCost, _CardSort.cost),
          // Pushed to the far edge: it filters rather than sorts, and the gap is what says so.
          const Spacer(),
          buildCollectionChip(),
        ],
      ),
    );
  }


  Widget _buildList() {
    if (_loading) {
      return Center(
        child: CircularProgressIndicator(color: context.accentColor),
      );
    }
    if (_error != null) {
      return ErrorRetryView(message: _error!, onRetry: _load);
    }
    if (_results.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context).cardsNoProfiles,
          style: TextStyle(color: context.subtleTextColor, fontSize: 14),
        ),
      );
    }
    final sorted = _sorted;
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: sorted.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (_, i) =>
          _ProfileTile(profile: sorted[i], profiles: sorted, index: i),
    );
  }
}


class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.profile,
    required this.profiles,
    required this.index,
  });
  final api.Profile profile;
  final List<api.Profile> profiles;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Drop a focused search field before opening the viewer, or popping it would restore
        // focus here and pop the keyboard back up (see dismissSearchFocusOnTapOutside).
        FocusManager.instance.primaryFocus?.unfocus();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                CardViewerScreen(profiles: profiles, initialIndex: index),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            gradient: AppPalette.entryTileGradient(
              AppPalette.factionColors[profile.faction] ?? context.cardBgColor,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Flexible(
                        child: Text(
                          profile.name,
                          style: GoogleFonts.cinzel(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (profile.keywords.contains('Leader') ||
                          profile.keywords.contains('Hero')) ...[
                        const SizedBox(width: 6),
                        Text(
                          profile.keywords.contains('Leader')
                              ? AppLocalizations.of(context).gangRoleLeader
                              : AppLocalizations.of(context).gangRoleHero,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withValues(alpha: 0.65),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                // Binary and quiet: owned at all, or nothing drawn. How many, and in what state,
                // belongs to the collection screen — a browse list only answers yes or no.
                if (collectionLive && CollectionService().owns(profile.id)) ...[
                  CollectionGlyph.mark(
                    color: CollectionGlyph.tileColorFor(CollectionState.painted),
                  ),
                  const SizedBox(width: 10),
                ],
                Text(
                  '${profile.ducats}',
                  style: GoogleFonts.cinzel(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
