import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/gang.dart';
import '../models/profile.dart';
import '../services/gang_service.dart';
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

const _kFactionIcons = {
  'doctors':    'assets/images/icons/doctors icon.png',
  'gifted':     'assets/images/icons/gifted icon.png',
  'guild':      'assets/images/icons/guild icon.png',
  'patricians': 'assets/images/icons/patricians icon.png',
  'rashaar':    'assets/images/icons/rashaar icon.png',
  'strigoi':    'assets/images/icons/strigoi icon.png',
  'vatican':    'assets/images/icons/vatican icon.png',
};

class GangBuilderScreen extends StatefulWidget {
  const GangBuilderScreen({super.key, required this.gang});
  final Gang gang;

  @override
  State<GangBuilderScreen> createState() => _GangBuilderScreenState();
}

class _GangBuilderScreenState extends State<GangBuilderScreen> {
  late Gang _gang;
  List<Profile> _profiles = [];
  bool _loading = true;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _gang = widget.gang;
    _loadData();
  }

  Future<void> _loadData() async {
    final profiles = await ProfileService().search('', factions: {_gang.faction});
    setState(() {
      _profiles = profiles;
      _loading = false;
    });
  }

  bool _hasEntry(Profile p) => _gang.entries.any((e) => e.referenceId == p.id);

  ListEntry? _entryFor(Profile p) {
    try {
      return _gang.entries.firstWhere((e) => e.referenceId == p.id);
    } catch (_) {
      return null;
    }
  }

  Future<void> _add(Profile p) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final updated = await GangService().addEntry(_gang.id, p.id);
      setState(() => _gang = updated);
    } finally {
      setState(() => _busy = false);
    }
  }

  Future<void> _remove(Profile p) async {
    final entry = _entryFor(p);
    if (entry == null || _busy) return;
    setState(() => _busy = true);
    try {
      final updated = await GangService().removeEntry(_gang.id, entry.id);
      setState(() => _gang = updated);
    } finally {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final factionColor = _kFactionColors[_gang.faction] ?? _kGold;
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
                    _buildHeader(context, factionColor),
                    _buildPointsBar(factionColor),
                    const SizedBox(height: 8),
                    Expanded(child: _buildProfileList(factionColor)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color factionColor) {
    final iconPath = _kFactionIcons[_gang.faction];
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: _kDarkText),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              _gang.name,
              style: GoogleFonts.cinzel(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: _kDarkText,
                letterSpacing: 2,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: factionColor, shape: BoxShape.circle),
            padding: const EdgeInsets.all(7),
            child: iconPath != null
                ? Image.asset(iconPath, fit: BoxFit.contain, color: Colors.white, colorBlendMode: BlendMode.srcIn)
                : const Icon(Icons.flag, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsBar(Color factionColor) {
    final used = _gang.totalCost;
    final limit = _gang.points;
    final ratio = limit > 0 ? (used / limit).clamp(0.0, 1.0) : 0.0;
    final isOver = used > limit;
    final barColor = isOver ? Colors.red.shade400 : _kGold;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.45),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 0.5),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '$used',
                      style: GoogleFonts.cinzel(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isOver ? Colors.red.shade600 : _kDarkText,
                      ),
                    ),
                    Text(
                      ' / $limit ducats',
                      style: GoogleFonts.cinzel(fontSize: 14, color: _kSubtleText),
                    ),
                    const Spacer(),
                    Text(
                      '${limit - used} left',
                      style: TextStyle(
                        fontSize: 12,
                        color: isOver ? Colors.red.shade400 : _kSubtleText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: ratio,
                    backgroundColor: Colors.black.withOpacity(0.08),
                    valueColor: AlwaysStoppedAnimation(barColor),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileList(Color factionColor) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: _kGold));
    }
    if (_profiles.isEmpty) {
      return Center(
        child: Text('No profiles for this faction.', style: TextStyle(color: _kSubtleText)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      itemCount: _profiles.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final p = _profiles[i];
        final inList = _hasEntry(p);
        final canAdd = !inList && (_gang.totalCost + p.ducats <= _gang.points);
        return _ProfileBuilderTile(
          profile: p,
          inList: inList,
          factionColor: factionColor,
          canAdd: canAdd,
          busy: _busy,
          onAdd: () => _add(p),
          onRemove: () => _remove(p),
        );
      },
    );
  }
}

class _ProfileBuilderTile extends StatelessWidget {
  const _ProfileBuilderTile({
    required this.profile,
    required this.inList,
    required this.factionColor,
    required this.canAdd,
    required this.busy,
    required this.onAdd,
    required this.onRemove,
  });

  final Profile profile;
  final bool inList;
  final Color factionColor;
  final bool canAdd;
  final bool busy;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: inList
                ? factionColor.withOpacity(0.12)
                : _kCardBg.withOpacity(0.65),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: inList ? factionColor.withOpacity(0.4) : Colors.white.withOpacity(0.3),
              width: inList ? 1.0 : 0.5,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name,
                        style: GoogleFonts.cinzel(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _kDarkText,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${profile.ducats} ducats',
                        style: TextStyle(
                          fontSize: 12,
                          color: inList ? factionColor : _kSubtleText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                _ToggleButton(
                  inList: inList,
                  canAdd: canAdd,
                  busy: busy,
                  factionColor: factionColor,
                  onAdd: onAdd,
                  onRemove: onRemove,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({
    required this.inList,
    required this.canAdd,
    required this.busy,
    required this.factionColor,
    required this.onAdd,
    required this.onRemove,
  });

  final bool inList;
  final bool canAdd;
  final bool busy;
  final Color factionColor;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    if (busy) {
      return SizedBox(
        width: 30, height: 30,
        child: CircularProgressIndicator(strokeWidth: 2, color: factionColor),
      );
    }
    if (inList) {
      return GestureDetector(
        onTap: onRemove,
        child: Container(
          width: 30, height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: factionColor.withOpacity(0.15),
            border: Border.all(color: factionColor.withOpacity(0.5)),
          ),
          child: Icon(Icons.remove, size: 16, color: factionColor),
        ),
      );
    }
    return GestureDetector(
      onTap: canAdd ? onAdd : null,
      child: Container(
        width: 30, height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: canAdd ? factionColor.withOpacity(0.15) : Colors.transparent,
          border: Border.all(
            color: canAdd ? factionColor.withOpacity(0.5) : _kSubtleText.withOpacity(0.2),
          ),
        ),
        child: Icon(
          Icons.add,
          size: 16,
          color: canAdd ? factionColor : _kSubtleText.withOpacity(0.3),
        ),
      ),
    );
  }
}
