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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_colors.dart';
import '../l10n/app_localizations.dart';
import '../models/profile_query.dart';
import '../services/profile_service.dart';
import 'glass_panel.dart';

/// The catalog search shared by the Cards screen and the gang builder's Hire tab: free text swept
/// across names/abilities/rules, plus facet autocomplete that promotes what you typed into an
/// exact, ANDed filter chip.
///
/// The two screens differ only in what they search *within* — the Cards screen lets you pick
/// factions, the Hire tab is pinned to the gang's own faction plus Gifted (you can't hire outside
/// them) — so that is the one thing [ProfileSearchMixin.searchFactions] leaves to the screen. The
/// layout is left to the screens too: both float the suggestions over their content in a Stack,
/// but what sits under them differs.

IconData facetIcon(FacetKind kind) => switch (kind) {
  FacetKind.keyword => Icons.local_offer_outlined,
  FacetKind.ability => Icons.auto_awesome_outlined,
  FacetKind.weaponAbility => Icons.gavel_outlined,
};

/// Drop-in catalog search for a screen that filters profiles: owns the text box, the picked facets,
/// the autocomplete and its keyboard navigation, and hands the screen a [ProfileQuery] to run.
///
/// The screen supplies [searchFactions] and [onSearchChanged] (where it recomputes its own results
/// from [searchQuery]), and composes [buildSearchField], [buildFacetChips] and [buildSuggestions]
/// into its layout.
mixin ProfileSearchMixin<T extends StatefulWidget> on State<T> {
  final searchController = TextEditingController();

  /// Tracks whether the search field is focused, so the suggestions panel can hide with the
  /// keyboard (tap outside to dismiss both) without losing the computed suggestions — they're
  /// only hidden, not cleared, so tapping back into the field brings them straight back.
  late final FocusNode searchFocusNode = FocusNode()..addListener(() => setState(() {}));

  /// Ties the suggestions panel to the search field as one tap region, so a tap on a suggestion
  /// does not count as a tap *outside* the field.
  ///
  /// Without it the panel is unreachable on web. EditableText's default tap-outside action drops
  /// focus the moment a pointer goes down anywhere outside the field — for a touch it spares
  /// native Android and iOS, but not kIsWeb — and this panel is shown only while the field has
  /// focus ([hasSuggestions]), so it was torn down between the pointer going down and coming back
  /// up. The row never completed its tap, and tapping a suggestion did nothing at all.
  final Object _searchTapGroup = Object();

  /// Exact filters picked from the autocomplete, ANDed together: Leader + Brave finds brave leaders.
  final Set<Facet> pickedFacets = {};

  List<FacetSuggestion> _suggestions = const [];

  /// Index into [_suggestions] of the arrow-key selection, or -1 when nothing is selected yet
  /// (in which case Enter takes the top hit).
  int _highlighted = -1;

  /// Per-row keys, so the arrow keys can scroll a selection that has moved out of view back in.
  final Map<int, GlobalKey> _suggestionKeys = {};

  /// The factions to search within. User-picked on the Cards screen; fixed on the Hire tab.
  Set<String> get searchFactions;

  /// Recompute the screen's results from [searchQuery]. Called inside a `setState`, so just assign
  /// — don't call `setState` again.
  void onSearchChanged();

  ProfileQuery get searchQuery => ProfileQuery(
    text: searchController.text,
    factions: searchFactions,
    facets: pickedFacets,
  );

  bool get hasSuggestions => _suggestions.isNotEmpty && searchFocusNode.hasFocus;

  /// Wraps [child] so tapping anywhere that isn't itself a focusable/tappable control drops focus
  /// from the search field — dismissing the keyboard, and with it (via [hasSuggestions]) the
  /// suggestions panel. Refocusing the field brings the same suggestions straight back.
  ///
  /// Unfocus the field itself, not `FocusScope.of(context)`: unfocusing the scope clears its
  /// parent's focused child, but leaves the enclosing route scope still remembering this field —
  /// so pushing then popping a card viewer would restore focus here and pop the keyboard back up.
  Widget dismissSearchFocusOnTapOutside({required Widget child}) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => searchFocusNode.unfocus(),
      child: child,
    );
  }

  void disposeSearch() {
    searchController.dispose();
    searchFocusNode.dispose();
  }

  /// The single funnel for every filter change. The catalog is already on the device, so this runs
  /// synchronously on each keystroke — no debounce, no round-trip.
  void applySearch() {
    setState(() {
      _suggestions = ProfileService().suggest(
        searchController.text,
        exclude: pickedFacets,
      );
      // The list just changed under it, so any previous selection is meaningless.
      _highlighted = -1;
      onSearchChanged();
    });
  }

  void addFacet(Facet facet) {
    pickedFacets.add(facet);
    // The text has been promoted into a chip, so clear it (this doesn't fire `onChanged`).
    searchController.clear();
    applySearch();
  }

  void removeFacet(Facet facet) {
    pickedFacets.remove(facet);
    applySearch();
  }

  /// Arrow keys walk the suggestions, Enter picks one, Escape dismisses them. Handled above the
  /// field, so the keys don't also move the text caret; anything else falls through to it.
  KeyEventResult _onSearchKey(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent || _suggestions.isEmpty) {
      return KeyEventResult.ignored;
    }

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowDown:
        _moveHighlight(1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowUp:
        _moveHighlight(-1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.enter:
      case LogicalKeyboardKey.numpadEnter:
        // Enter with nothing selected takes the top hit, so you can type and confirm without
        // reaching for the arrows at all.
        addFacet(_suggestions[_highlighted < 0 ? 0 : _highlighted].facet);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.escape:
        setState(() {
          _suggestions = const [];
          _highlighted = -1;
        });
        return KeyEventResult.handled;
      default:
        return KeyEventResult.ignored;
    }
  }

  void _moveHighlight(int delta) {
    setState(() {
      // From "nothing selected", Down lands on the first hit and Up wraps to the last.
      final from = _highlighted >= 0 ? _highlighted : (delta > 0 ? -1 : 0);
      _highlighted = (from + delta + _suggestions.length) % _suggestions.length;
    });
    // A long suggestion list scrolls inside its panel, so keep the selection on screen.
    final key = _suggestionKeys[_highlighted];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = key?.currentContext;
      if (context == null) return;
      Scrollable.ensureVisible(
        context,
        alignment: 0.5,
        duration: const Duration(milliseconds: 120),
      );
    });
  }

  Widget buildSearchField({
    String? hintText,
  }) {
    hintText ??= AppLocalizations.of(context).summonSearchHint;
    return GlassPanel(
      padding: EdgeInsets.zero,
      // canRequestFocus: false — this node only listens for keys on their way up from the field,
      // it must never take focus away from it.
      child: Focus(
        canRequestFocus: false,
        onKeyEvent: _onSearchKey,
        child: TextField(
          controller: searchController,
          focusNode: searchFocusNode,
          // Grouped with the suggestions panel; see [_searchTapGroup].
          groupId: _searchTapGroup,
          onChanged: (_) => applySearch(),
          style: TextStyle(color: context.textColor, fontSize: 15),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: context.subtleTextColor.withValues(alpha: 0.7),
              fontSize: 15,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: context.accentColor,
              size: 20,
            ),
            suffixIcon: searchController.text.isEmpty
                ? null
                : IconButton(
                    icon: Icon(
                      Icons.close,
                      color: context.subtleTextColor,
                      size: 18,
                    ),
                    onPressed: () {
                      // clear() doesn't fire the field's onChanged, so re-run the query by hand.
                      searchController.clear();
                      applySearch();
                    },
                  ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  /// The picked filters, shown under the search box until dismissed. Empty when nothing is picked,
  /// so a screen can render it unconditionally.
  Widget buildFacetChips() {
    if (pickedFacets.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final facet in pickedFacets)
          FacetChip(facet: facet, onRemove: () => removeFacet(facet)),
      ],
    );
  }

  /// The autocomplete: abilities, keywords and weapon abilities whose name matches what's typed.
  /// Tapping one promotes it from free text to an exact filter (a chip), which is how you ask for
  /// "Leader AND Brave" — a question plain text can't express.
  Widget buildSuggestions() {
    return TapRegion(
      // Same group as the search field, so pressing a row is "inside" it and the field keeps focus
      // long enough for the tap to complete. See [_searchTapGroup].
      groupId: _searchTapGroup,
      child: DecoratedBox(
        // Lifts the panel off the content it now floats over.
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.28),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: GlassPanel(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 232),
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: _suggestions.length,
              itemBuilder: (_, i) {
                final suggestion = _suggestions[i];
                return SuggestionRow(
                  key: _suggestionKeys.putIfAbsent(i, GlobalKey.new),
                  suggestion: suggestion,
                  selected: i == _highlighted,
                  onTap: () => addFacet(suggestion.facet),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// A picked filter, shown under the search box until it's dismissed.
class FacetChip extends StatelessWidget {
  const FacetChip({super.key, required this.facet, required this.onRemove});

  final Facet facet;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final accent = context.accentColor;
    return Container(
      padding: const EdgeInsets.fromLTRB(9, 5, 5, 5),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.45), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(facetIcon(facet.kind), size: 12, color: accent),
          const SizedBox(width: 5),
          Text(
            facet.name,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: context.textColor,
            ),
          ),
          const SizedBox(width: 2),
          GestureDetector(
            onTap: onRemove,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Icon(
                Icons.close,
                size: 12,
                color: context.subtleTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One autocomplete hit: the facet's name, what kind it is and how many models have it.
class SuggestionRow extends StatelessWidget {
  const SuggestionRow({
    super.key,
    required this.suggestion,
    required this.selected,
    required this.onTap,
  });

  final FacetSuggestion suggestion;

  /// True when the arrow keys have landed on this row; Enter would pick it.
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: selected
            ? context.accentColor.withValues(alpha: 0.16)
            : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Icon(
              facetIcon(suggestion.facet.kind),
              size: 16,
              color: context.accentColor,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                suggestion.facet.name,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: context.textColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${suggestion.facet.kind.label} · ${suggestion.count}',
              style: TextStyle(fontSize: 10.5, color: context.subtleTextColor),
            ),
          ],
        ),
      ),
    );
  }
}
