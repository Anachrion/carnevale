import '../app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import '../models/profile_query.dart';
import '../services/profile_service.dart';
import '../widgets/app_background.dart';
import '../widgets/app_drawer.dart';
import '../widgets/glass_panel.dart';
import '../widgets/screen_header.dart';
import '../widgets/sort_chip.dart';
import 'card_viewer_screen.dart';

enum _CardSort { name, cost }

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();
  final _service = ProfileService();

  List<api.Profile> _results = [];
  // Cached sorted view of _results; recomputed only when the results or sort change (F-P3-6).
  List<api.Profile> _sorted = [];
  final Set<String> _selectedFactions = {};
  // Exact filters picked from the autocomplete, ANDed together: Leader + Brave finds brave leaders.
  final Set<Facet> _facets = {};
  List<FacetSuggestion> _suggestions = const [];
  /// Index into [_suggestions] of the arrow-key selection, or -1 when nothing is selected yet
  /// (in which case Enter takes the top hit).
  int _highlighted = -1;
  /// Per-row keys, so the arrow keys can scroll a selection that has moved out of view back in.
  final Map<int, GlobalKey> _suggestionKeys = {};
  bool _loading = true;
  _CardSort _sort = _CardSort.name;
  bool _sortAsc = true;

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
      }
    });
    _sorted = list;
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    await _service.loadAll();
    if (!mounted) return;
    setState(() => _loading = false);
    _applyQuery();
  }

  /// The single funnel for every filter change. The catalog is already on the device, so this runs
  /// synchronously on each keystroke — no debounce, no round-trip.
  void _applyQuery() {
    final text = _searchController.text;
    setState(() {
      _results = _service.matching(
        ProfileQuery(
          text: text,
          factions: _selectedFactions,
          facets: _facets,
        ),
      );
      _suggestions = _service.suggest(text, exclude: _facets);
      // The list just changed under it, so any previous selection is meaningless.
      _highlighted = -1;
      _recomputeSorted();
    });
  }

  /// Arrow keys walk the suggestions, Enter picks one, Escape dismisses them. Handled here, above
  /// the field, so the keys don't also move the text caret; anything else falls through to it.
  KeyEventResult _onSearchKey(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent || _suggestions.isEmpty) return KeyEventResult.ignored;

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
        _addFacet(_suggestions[_highlighted < 0 ? 0 : _highlighted].facet);
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
      final from = _highlighted >= 0
          ? _highlighted
          : (delta > 0 ? -1 : 0);
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

  void _addFacet(Facet facet) {
    _facets.add(facet);
    // The text has been promoted into a chip, so clear it (this doesn't fire `onChanged`).
    _searchController.clear();
    _applyQuery();
  }

  void _removeFacet(Facet facet) {
    _facets.remove(facet);
    _applyQuery();
  }

  void _toggleFaction(String faction) {
    if (!_selectedFactions.remove(faction)) _selectedFactions.add(faction);
    _applyQuery();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppPalette.background,
      drawer: const AppDrawer(current: AppDrawerRoute.cards),
      body: AppBackground(
        child: Column(
          children: [
            _buildHeader(context),
            _buildSearchBar(),
            if (_facets.isNotEmpty) _buildFacetChips(),
            // The suggestions float over the filters and the card list rather than sitting in the
            // column, so opening them doesn't shove the page down. Stacking them inside the area
            // below the search box (not over the whole screen) keeps them hit-testable, and lets
            // the panel's backdrop filter blur the cards showing through it.
            Expanded(
              child: Stack(
                children: [
                  Column(
                    children: [
                      _buildFactionFilter(),
                      _buildSortChips(),
                      const SizedBox(height: 8),
                      Expanded(child: _buildList()),
                    ],
                  ),
                  if (_suggestions.isNotEmpty)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: _buildSuggestions(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return ScreenHeader(
      title: 'Cards',
      onMenu: () => _scaffoldKey.currentState?.openDrawer(),
      trailing: Text(
        '${_results.length} profiles',
        style: TextStyle(fontSize: 12, color: context.subtleTextColor),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: GlassPanel(
        padding: EdgeInsets.zero,
        // canRequestFocus: false — this node only listens for keys on their way up from the field,
        // it must never take focus away from it.
        child: Focus(
          canRequestFocus: false,
          onKeyEvent: _onSearchKey,
          child: TextField(
            controller: _searchController,
            onChanged: (_) => _applyQuery(),
            style: TextStyle(color: context.textColor, fontSize: 15),
            decoration: InputDecoration(
              hintText: 'Search names, abilities, rules...',
              hintStyle: TextStyle(
                color: context.subtleTextColor.withValues(alpha: 0.7),
                fontSize: 15,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: context.accentColor,
                size: 20,
              ),
              suffixIcon: _searchController.text.isEmpty
                  ? null
                  : IconButton(
                      icon: Icon(
                        Icons.close,
                        color: context.subtleTextColor,
                        size: 18,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        _applyQuery();
                      },
                    ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
      ),
    );
  }

  /// The autocomplete: abilities, keywords and weapon abilities whose name matches what's typed.
  /// Tapping one promotes it from free text to an exact filter (a chip), which is how you ask for
  /// "Leader AND Brave" — a question plain text can't express.
  Widget _buildSuggestions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: DecoratedBox(
        // Lifts the panel off the cards it now floats over.
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
                return _SuggestionRow(
                  key: _suggestionKeys.putIfAbsent(i, GlobalKey.new),
                  suggestion: suggestion,
                  selected: i == _highlighted,
                  onTap: () => _addFacet(suggestion.facet),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFacetChips() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          for (final facet in _facets)
            _FacetChip(facet: facet, onRemove: () => _removeFacet(facet)),
        ],
      ),
    );
  }

  Widget _buildSortChips() {
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
          chip('Name', _CardSort.name),
          const SizedBox(width: 6),
          chip('Cost', _CardSort.cost),
        ],
      ),
    );
  }

  Widget _buildFactionFilter() {
    final factions = [
      'guild',
      'doctors',
      'vatican',
      'patricians',
      'strigoi',
      'gifted',
      'rashaar',
    ];
    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          ...factions.map(
            (f) => _FactionIconChip(
              faction: f,
              selected: _selectedFactions.contains(f),
              onTap: () => _toggleFaction(f),
            ),
          ),
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
    if (_results.isEmpty) {
      return Center(
        child: Text(
          'No profiles found.',
          style: TextStyle(color: context.subtleTextColor, fontSize: 14),
        ),
      );
    }
    final sorted = _sorted;
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: sorted.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) =>
          _ProfileTile(profile: sorted[i], profiles: sorted, index: i),
    );
  }
}

IconData _facetIcon(FacetKind kind) => switch (kind) {
  FacetKind.keyword => Icons.local_offer_outlined,
  FacetKind.ability => Icons.auto_awesome_outlined,
  FacetKind.weaponAbility => Icons.gavel_outlined,
};

/// One autocomplete hit: the facet's name, what kind it is and how many models have it, over the
/// rulebook text when the glossary knows the ability.
class _SuggestionRow extends StatelessWidget {
  const _SuggestionRow({
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
              _facetIcon(suggestion.facet.kind),
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
              style: TextStyle(
                fontSize: 10.5,
                color: context.subtleTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A picked filter, shown under the search box until it's dismissed.
class _FacetChip extends StatelessWidget {
  const _FacetChip({required this.facet, required this.onRemove});

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
          Icon(_facetIcon(facet.kind), size: 12, color: accent),
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
              child: Icon(Icons.close, size: 12, color: context.subtleTextColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _FactionIconChip extends StatelessWidget {
  const _FactionIconChip({
    required this.faction,
    required this.selected,
    required this.onTap,
  });
  final String faction;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = AppPalette.factionColors[faction] ?? context.accentColor;
    final iconPath = AppPalette.factionIcons[faction]!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? color : color.withValues(alpha: 0.5),
        ),
        padding: const EdgeInsets.all(4),
        child: Image.asset(
          iconPath,
          fit: BoxFit.contain,
          color: selected ? Colors.white : Colors.white.withValues(alpha: 0.35),
          colorBlendMode: BlendMode.srcIn,
        ),
      ),
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
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              CardViewerScreen(profiles: profiles, initialIndex: index),
        ),
      ),
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
                              ? 'leader'
                              : 'hero',
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
