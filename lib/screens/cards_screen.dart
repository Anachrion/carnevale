import '../app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
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
  final Set<String> _selectedFactions = {};
  bool _loading = true;
  _CardSort _sort = _CardSort.name;
  bool _sortAsc = true;

  List<api.Profile> get _sortedResults {
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
    return list;
  }

  @override
  void initState() {
    super.initState();
    _load();
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final results = await _service.search('');
    if (!mounted) return;
    setState(() {
      _results = results;
      _loading = false;
    });
  }

  Future<void> _onSearch() async {
    final results = await _service.search(
      _searchController.text,
      factions: _selectedFactions,
    );
    if (!mounted) return;
    setState(() => _results = results);
  }

  Future<void> _toggleFaction(String faction) async {
    if (_selectedFactions.contains(faction)) {
      _selectedFactions.remove(faction);
    } else {
      _selectedFactions.add(faction);
    }
    await _onSearch();
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
            _buildFactionFilter(),
            _buildSortChips(),
            const SizedBox(height: 8),
            Expanded(child: _buildList()),
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
        child: TextField(
          controller: _searchController,
          style: TextStyle(color: context.textColor, fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Search profiles...',
            hintStyle: TextStyle(
              color: context.subtleTextColor.withValues(alpha: 0.7),
              fontSize: 15,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: AppPalette.gold,
              size: 20,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
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
      return const Center(
        child: CircularProgressIndicator(color: AppPalette.gold),
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
    final sorted = _sortedResults;
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: sorted.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) =>
          _ProfileTile(profile: sorted[i], profiles: sorted, index: i),
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
    final color = AppPalette.factionColors[faction] ?? AppPalette.gold;
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
            color:
                AppPalette.factionColors[profile.faction] ??
                context.cardBgColor,
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
