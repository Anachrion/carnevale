import 'dart:ui';
import '../app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/profile.dart';
import '../services/profile_service.dart';
import '../widgets/app_drawer.dart';
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

  List<Profile> _results = [];
  final Set<String> _selectedFactions = {};
  bool _loading = true;
  _CardSort _sort = _CardSort.name;
  bool _sortAsc = true;

  List<Profile> get _sortedResults {
    final list = List<Profile>.from(_results);
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
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                Theme.of(context).brightness == Brightness.dark
                    ? 'assets/images/bg_dark.png'
                    : 'assets/images/bg_light.png',
              ),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(color: Colors.black.withOpacity(0.05)),
                ),
              ),
              SafeArea(
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.menu, color: context.textColor),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
          const SizedBox(width: 4),
          Text(
            'Cards',
            style: GoogleFonts.cinzel(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: context.textColor,
              letterSpacing: 3,
            ),
          ),
          const Spacer(),
          Text(
            '${_results.length} profiles',
            style: TextStyle(fontSize: 12, color: context.subtleTextColor),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              gradient: Theme.of(context).brightness == Brightness.dark
                  ? const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x10000000), Color(0x88000000)],
                    )
                  : LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppPalette.paper.withOpacity(0.30),
                        AppPalette.paper.withOpacity(0.75),
                      ],
                    ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppPalette.mutedGold.withOpacity(0.45)
                    : Colors.white.withOpacity(0.3),
                width: 1.0,
              ),
            ),
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: context.textColor, fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Search profiles...',
                hintStyle: TextStyle(color: context.subtleTextColor.withOpacity(0.7), fontSize: 15),
                prefixIcon: const Icon(Icons.search, color: AppPalette.gold, size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSortChips() {
    final accent = Theme.of(context).brightness == Brightness.dark
        ? AppPalette.gold
        : AppPalette.red;
    Widget chip(String label, _CardSort value) {
      final selected = _sort == value;
      return GestureDetector(
        onTap: () => setState(() {
          if (_sort == value) {
            _sortAsc = !_sortAsc;
          } else {
            _sort = value;
            _sortAsc = true;
          }
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: selected ? accent.withOpacity(0.85) : Colors.white.withOpacity(0.35),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? accent : Colors.white.withOpacity(0.4),
              width: 0.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? Colors.white : context.subtleTextColor,
                  letterSpacing: 0.5,
                ),
              ),
              if (selected) ...[
                const SizedBox(width: 3),
                Icon(
                  _sortAsc ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 10,
                  color: Colors.white,
                ),
              ],
            ],
          ),
        ),
      );
    }

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
    final factions = ['guild', 'doctors', 'vatican', 'patricians', 'strigoi', 'gifted', 'rashaar'];
    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          ...factions.map((f) => _FactionIconChip(
                faction: f,
                selected: _selectedFactions.contains(f),
                onTap: () => _toggleFaction(f),
              )),
        ],
      ),
    );
  }

  Widget _buildList() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: AppPalette.gold));
    }
    if (_results.isEmpty) {
      return Center(
        child: Text('No profiles found.', style: TextStyle(color: context.subtleTextColor, fontSize: 14)),
      );
    }
    final sorted = _sortedResults;
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: sorted.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => _ProfileTile(profile: sorted[i], profiles: sorted, index: i),
    );
  }

  String _factionLabel(String f) => f[0].toUpperCase() + f.substring(1);
}

class _AllChip extends StatelessWidget {
  const _AllChip({required this.selected, required this.onTap});
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: selected ? AppPalette.gold : Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppPalette.gold : Colors.white.withOpacity(0.4),
            width: selected ? 2 : 1,
          ),
        ),
        child: Text(
          'All',
          style: GoogleFonts.cinzel(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
            color: selected ? Colors.white : context.textColor,
          ),
        ),
      ),
    );
  }
}

class _FactionIconChip extends StatelessWidget {
  const _FactionIconChip({required this.faction, required this.selected, required this.onTap});
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
          color: selected ? color : color.withOpacity(0.5),
        ),
        padding: const EdgeInsets.all(4),
        child: Image.asset(
          iconPath,
          fit: BoxFit.contain,
          color: selected ? Colors.white : Colors.white.withOpacity(0.35),
          colorBlendMode: BlendMode.srcIn,
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({required this.profile, required this.profiles, required this.index});
  final Profile profile;
  final List<Profile> profiles;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CardViewerScreen(
          profiles: profiles,
          initialIndex: index,
        )),
      ),
      child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
          decoration: BoxDecoration(
            color: AppPalette.factionColors[profile.faction] ?? context.cardBgColor,
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
                          style: GoogleFonts.cinzel(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (profile.keywords.contains('Leader') || profile.keywords.contains('Hero')) ...[
                        const SizedBox(width: 6),
                        Text(
                          profile.keywords.contains('Leader') ? 'leader' : 'hero',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withOpacity(0.65),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Text(
                  '${profile.ducats}',
                  style: GoogleFonts.cinzel(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statBadge(String label, int value) {
    return Column(
      children: [
        Text(value.toString(), style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
        Text(label, style: const TextStyle(fontSize: 9, color: Colors.white70, letterSpacing: 0.5)),
      ],
    );
  }

  String _factionLabel(String f) => f[0].toUpperCase() + f.substring(1);
}
