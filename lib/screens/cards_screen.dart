import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/profile.dart';
import '../services/profile_service.dart';

const _kBackground = Color(0xFFF0EDE6);
const _kDarkText = Color(0xFF2C2418);
const _kGold = Color(0xFFC4A050);
const _kSubtleText = Color(0xFF7A6E62);
const _kCardBg = Color(0xFFF5F2EE);

const _kFactionColors = {
  'doctors':    Color(0xFF177282),
  'strigoi':    Color(0xFF2a3d6e),
  'gifted':     Color(0xFFb04510),
  'rashaar':    Color(0xFF1a5a40),
  'patricians': Color(0xFF5a1a7a),
  'vatican':    Color(0xFF8a6018),
  'guild':      Color(0xFF831822),
};

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  final _searchController = TextEditingController();
  final _service = ProfileService();

  List<Profile> _results = [];
  String? _selectedFaction;
  bool _loading = true;

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
      faction: _selectedFaction,
    );
    setState(() => _results = results);
  }

  Future<void> _setFaction(String? faction) async {
    _selectedFaction = faction;
    await _onSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackground,
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg_light.png'),
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
                    const SizedBox(height: 28),
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
            icon: const Icon(Icons.arrow_back, color: _kDarkText),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 4),
          Text(
            'Cards',
            style: GoogleFonts.cinzel(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: _kDarkText,
              letterSpacing: 3,
            ),
          ),
          const Spacer(),
          Text(
            '${_results.length} profiles',
            style: const TextStyle(fontSize: 12, color: _kSubtleText),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 0.5),
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: _kDarkText, fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Search profiles...',
                hintStyle: TextStyle(color: _kSubtleText.withOpacity(0.7), fontSize: 15),
                prefixIcon: const Icon(Icons.search, color: _kGold, size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFactionFilter() {
    final factions = ['guild', 'doctors', 'vatican', 'patricians', 'strigoi', 'gifted', 'rashaar'];
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _FactionChip(label: 'All', selected: _selectedFaction == null, onTap: () => _setFaction(null)),
          ...factions.map((f) => _FactionChip(
                label: _factionLabel(f),
                selected: _selectedFaction == f,
                onTap: () => _setFaction(_selectedFaction == f ? null : f),
              )),
        ],
      ),
    );
  }

  Widget _buildList() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: _kGold));
    }
    if (_results.isEmpty) {
      return Center(
        child: Text('No profiles found.', style: TextStyle(color: _kSubtleText, fontSize: 14)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: _results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => _ProfileTile(profile: _results[i]),
    );
  }

  String _factionLabel(String f) => f[0].toUpperCase() + f.substring(1);
}

class _FactionChip extends StatelessWidget {
  const _FactionChip({required this.label, required this.selected, required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? _kGold : Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? _kGold : Colors.white.withOpacity(0.4)),
        ),
        child: Text(
          label,
          style: GoogleFonts.cinzel(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
            color: selected ? Colors.white : _kDarkText,
          ),
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({required this.profile});
  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
          decoration: BoxDecoration(
            color: _kFactionColors[profile.faction] ?? _kCardBg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(profile.name, style: GoogleFonts.cinzel(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
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
