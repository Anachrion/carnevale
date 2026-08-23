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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_colors.dart';
import '../l10n/app_localizations.dart';
import '../services/collection_service.dart';
import '../services/profile_service.dart';
import '../widgets/app_toast.dart';
import '../widgets/collection_dialog.dart';
import '../widgets/collection_glyph.dart';
import '../widgets/faction_filter_row.dart';
import '../widgets/profile_search.dart';

/// One side of the Collection screen: either the shelf, or what could go on it.
///
/// The same widget serves both because they differ only in which side of [CollectionService.owns]
/// a profile has to fall on, and in what the row's trailing control does — everything else (the
/// search, the faction filter, the tile) is identical, and two near-copies would drift.
///
/// Each instance keeps its own search text and scroll position across a tab switch
/// ([AutomaticKeepAliveClientMixin]), so flipping to "Add", finding a model and flipping back
/// returns you exactly where you were. The faction picks are the exception — they belong to the
/// screen, see [factions].
class CollectionTab extends StatefulWidget {
  const CollectionTab({
    super.key,
    required this.profiles,
    required this.owned,
    required this.factions,
    required this.onToggleFaction,
  });

  final List<api.Profile> profiles;

  /// True for the shelf, false for what is still missing from it.
  final bool owned;

  /// Owned by the screen rather than by this tab, so the progress panel above always describes the
  /// rows below it, and a faction stays picked when you flip between the two sides — "what have I
  /// got of the Guild" and "what am I still missing" are one train of thought.
  final Set<String> factions;
  final ValueChanged<String> onToggleFaction;

  @override
  State<CollectionTab> createState() => _CollectionTabState();
}

class _CollectionTabState extends State<CollectionTab>
    with ProfileSearchMixin, AutomaticKeepAliveClientMixin {
  List<api.Profile> _results = const [];

  @override
  bool get wantKeepAlive => true;

  @override
  Set<String> get searchFactions => widget.factions;

  @override
  void onSearchChanged() => _results = _filtered();

  @override
  void initState() {
    super.initState();
    // A row moves between the two tabs the moment its first miniature is added or its last one
    // removed, so both sides have to recompute when the collection does.
    CollectionService().addListener(_onCollectionChanged);
    _results = _filtered();
  }

  @override
  void dispose() {
    CollectionService().removeListener(_onCollectionChanged);
    disposeSearch();
    super.dispose();
  }

  void _onCollectionChanged() {
    if (mounted) setState(() => _results = _filtered());
  }

  @override
  void didUpdateWidget(CollectionTab old) {
    super.didUpdateWidget(old);
    // The faction picks live on the screen and arrive as a fresh set each build, so compare
    // contents rather than identity; a change there has to re-run this tab's own search.
    if (!setEquals(old.factions, widget.factions)) {
      setState(() => _results = _filtered());
    }
  }

  /// The search, then the side of the shelf this tab shows. Deliberately not routed through
  /// [ProfileQuery.ownedIds]: that expresses "only these", and the Add tab needs the complement.
  List<api.Profile> _filtered() => ProfileService()
      .matching(searchQuery)
      .where((p) => CollectionService().owns(p.id) == widget.owned)
      .toList();

  /// Puts a first miniature on the shelf and opens the counter dialog on it, at once.
  ///
  /// Without that second step the row vanishes into the other tab the moment it is added, and
  /// saying "it is built, and one of them is painted" means going to find it again — so the
  /// natural follow-up is offered where the thought already is.
  ///
  /// The write is deliberately *not* awaited before the dialog opens. [CollectionService.setCount]
  /// applies the new count locally before its first await, so the dialog already has the right
  /// state to show; awaiting the round trip first only put a visible pause between the tap and the
  /// dialog. A write that then fails rolls the count back — the open dialog follows it, since it
  /// listens to the service — and says so.
  void _add(api.Profile profile) {
    final l10n = AppLocalizations.of(context);
    final pending = CollectionService().setCount(
      profile.id,
      CollectionCount.owned,
      1,
    );
    unawaited(
      pending.then((ok) {
        if (!ok && mounted) showAppToast(context, l10n.collectionSaveFailed);
      }),
    );
    showCollectionDialog(context, profile);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context);

    return dismissSearchFocusOnTapOutside(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: buildSearchField(
              hintText: widget.owned
                  ? l10n.collectionSearchMine
                  : l10n.collectionSearchAdd,
            ),
          ),
          if (pickedFacets.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
              child: buildFacetChips(),
            ),
          Expanded(
            child: Stack(
              children: [
                Column(
                  children: [
                    FactionFilterRow(
                      selected: widget.factions,
                      onToggle: widget.onToggleFaction,
                    ),
                    if (!widget.owned) _buildAbsentCount(),
                    const SizedBox(height: 4),
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
    );
  }

  /// How much of the catalogue is still missing — the number this tab exists to shrink.
  Widget _buildAbsentCount() {
    final absent = widget.profiles
        .where((p) => !CollectionService().owns(p.id))
        .length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          AppLocalizations.of(context).collectionAbsentCount(absent),
          style: TextStyle(fontSize: 11, color: context.subtleTextColor),
        ),
      ),
    );
  }

  Widget _buildList() {
    final l10n = AppLocalizations.of(context);
    if (_results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            widget.owned ? l10n.collectionEmpty : l10n.collectionAllAdded,
            textAlign: TextAlign.center,
            style: TextStyle(color: context.subtleTextColor, fontSize: 14),
          ),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: _results.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final profile = _results[i];
        return _CollectionTile(
          profile: profile,
          owned: widget.owned,
          onTap: widget.owned
              ? () => showCollectionDialog(context, profile)
              : () => _add(profile),
        );
      },
    );
  }
}

/// A row on either tab. No ducat cost: this screen is about miniatures on a shelf, not about what
/// they would cost to field, and the counts are what the eye should land on.
class _CollectionTile extends StatelessWidget {
  const _CollectionTile({
    required this.profile,
    required this.owned,
    required this.onTap,
  });

  final api.Profile profile;
  final bool owned;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final entry = CollectionService().entryFor(profile.id);
    final buckets = <(CollectionState, int)>[
      (CollectionState.painted, entry.painted),
      (CollectionState.built, entry.unpainted),
      (CollectionState.boxed, entry.boxed),
    ].where((bucket) => bucket.$2 > 0).toList();

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            gradient: AppPalette.entryTileGradient(
              AppPalette.factionColors[profile.faction] ?? context.cardBgColor,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Row(
            children: [
              Expanded(
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
              if (owned)
                for (final (state, count) in buckets) ...[
                  const SizedBox(width: 6),
                  _CountChip(state: state, count: count),
                ]
              else
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.2),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                  child: const Icon(Icons.add, size: 16, color: Colors.white),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountChip extends StatelessWidget {
  const _CountChip({required this.state, required this.count});

  final CollectionState state;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CollectionGlyph(
            state: state,
            color: CollectionGlyph.tileColorFor(state),
            size: 14,
          ),
          const SizedBox(width: 5),
          Text(
            '$count',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
