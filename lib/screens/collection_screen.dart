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

import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_colors.dart';
import '../l10n/app_localizations.dart';
import '../services/api_exception.dart';
import '../services/collection_service.dart';
import '../services/profile_service.dart';
import 'collection_tab.dart';
import '../widgets/app_background.dart';
import '../widgets/app_drawer.dart';
import '../widgets/collection_glyph.dart';
import '../widgets/glass_panel.dart';
import '../widgets/screen_header.dart';
import '../widgets/status_views.dart';

/// Managing the shelf: what the player owns, and what they could add (CARNEVALEB-76).
///
/// Two tabs, because they answer two different questions and one search box serving both would
/// never make clear which shelf you were searching. Each keeps its own text, faction filter and
/// scroll position across a switch, the way the gang builder's Liste/Engager pair does.
class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _pageController = PageController();

  List<api.Profile> _profiles = [];
  bool _loading = true;
  String? _error;
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    CollectionService().addListener(_onCollectionChanged);
    _load();
  }

  @override
  void dispose() {
    CollectionService().removeListener(_onCollectionChanged);
    _pageController.dispose();
    super.dispose();
  }

  void _onCollectionChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final profiles = await ProfileService().loadAll();
      // Unlike the browse screens, the collection *is* the subject here — a failure to load it is
      // a failure of the screen, so it is awaited rather than fired and forgotten.
      await CollectionService().load();
      if (!mounted) return;
      setState(() {
        _profiles = profiles;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e is ApiException
            ? e.message
            : AppLocalizations.of(context).errorCouldNotReachServer;
        _loading = false;
      });
    }
  }

  void _selectTab(int tab) {
    setState(() => _tab = tab);
    _pageController.animateToPage(
      tab,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppPalette.background,
      drawer: const AppDrawer(current: AppDrawerRoute.collection),
      body: AppBackground(
        child: Column(
          children: [
            ScreenHeader(
              title: AppLocalizations.of(context).navCollection,
              onMenu: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            _buildProgress(),
            const SizedBox(height: 12),
            _buildTabBar(),
            const SizedBox(height: 8),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return Center(
        child: CircularProgressIndicator(color: context.accentColor),
      );
    }
    if (_error != null) return ErrorRetryView(message: _error!, onRetry: _load);
    return PageView(
      controller: _pageController,
      onPageChanged: (page) => setState(() => _tab = page),
      children: [
        CollectionTab(profiles: _profiles, owned: true),
        CollectionTab(profiles: _profiles, owned: false),
      ],
    );
  }

  /// How far along the whole shelf is. Built on the same glass-panel-and-bar recipe as the gang
  /// builder's ducat meter, so the two read as the same kind of statement.
  ///
  /// The headline counts *profiles* against the catalogue — how much of the range is on the shelf —
  /// while the bar underneath shows what those miniatures are: painted, assembled, still boxed.
  /// Two different units, so they are never mixed inside one figure.
  Widget _buildProgress() {
    final l10n = AppLocalizations.of(context);
    final totals = CollectionService().totals;
    final ownedProfiles = CollectionService().ownedProfileCount;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: GlassPanel(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  l10n.collectionProgress(ownedProfiles, _profiles.length),
                  style: GoogleFonts.cinzel(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: context.textColor,
                  ),
                ),
                const Spacer(),
                Text(
                  l10n.collectionProgressDetail(totals.owned, totals.painted),
                  style: TextStyle(
                    fontSize: 12,
                    color: context.subtleTextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _CompositionBar(
              painted: totals.painted,
              built: totals.built - totals.painted,
              boxed: totals.owned - totals.built,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassPanel(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            _TabButton(
              label: l10n.collectionTabMine,
              selected: _tab == 0,
              onTap: () => _selectTab(0),
            ),
            _TabButton(
              label: l10n.collectionTabAdd,
              selected: _tab == 1,
              onTap: () => _selectTab(1),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = context.accentColor;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? accent : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.cinzel(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : context.subtleTextColor,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}

/// What the owned miniatures actually are, as one bar: painted, assembled, still boxed. The
/// segments are exclusive and together fill the width — it describes a composition, not progress
/// toward a target, so it is always full and never lies about a total.
class _CompositionBar extends StatelessWidget {
  const _CompositionBar({
    required this.painted,
    required this.built,
    required this.boxed,
  });

  final int painted;
  final int built;
  final int boxed;

  @override
  Widget build(BuildContext context) {
    final total = painted + built + boxed;
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: 6,
        child: total == 0
            ? ColoredBox(color: Colors.black.withValues(alpha: 0.08))
            : Row(
                children: [
                  for (final (state, count) in [
                    (CollectionState.painted, painted),
                    (CollectionState.built, built),
                    (CollectionState.boxed, boxed),
                  ])
                    if (count > 0)
                      Expanded(
                        flex: count,
                        child: ColoredBox(
                          color: CollectionGlyph.surfaceColorFor(
                            context,
                            state,
                          ),
                        ),
                      ),
                ],
              ),
      ),
    );
  }
}
