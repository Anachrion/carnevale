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

  @override
  void initState() {
    super.initState();
    _gang = widget.gang;
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    final all = await ProfileService().search('', factions: {_gang.faction});
    setState(() {
      _profiles = all;
      _loading = false;
    });
  }

  int _countFor(Profile p) {
    final m = _gang.members.where((m) => m.profileId == p.id);
    return m.isEmpty ? 0 : m.first.count;
  }

  void _increment(Profile p) {
    if (_gang.totalDucats + p.ducats > _gang.pointLimit) return;
    final members = List<GangMember>.from(_gang.members);
    final idx = members.indexWhere((m) => m.profileId == p.id);
    if (idx >= 0) {
      members[idx] = members[idx].copyWith(count: members[idx].count + 1);
    } else {
      members.add(GangMember(
        profileId: p.id,
        profileName: p.name,
        faction: p.faction,
        ducats: p.ducats,
        count: 1,
      ));
    }
    _applyUpdate(members);
  }

  void _decrement(Profile p) {
    final members = List<GangMember>.from(_gang.members);
    final idx = members.indexWhere((m) => m.profileId == p.id);
    if (idx < 0) return;
    if (members[idx].count <= 1) {
      members.removeAt(idx);
    } else {
      members[idx] = members[idx].copyWith(count: members[idx].count - 1);
    }
    _applyUpdate(members);
  }

  void _applyUpdate(List<GangMember> members) {
    setState(() => _gang = _gang.copyWith(members: members));
    GangService().save(_gang);
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
    final used = _gang.totalDucats;
    final limit = _gang.pointLimit;
    final ratio = (used / limit).clamp(0.0, 1.0);
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
                      style: GoogleFonts.cinzel(
                        fontSize: 14,
                        color: _kSubtleText,
                      ),
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
        final count = _countFor(p);
        final canAdd = _gang.totalDucats + p.ducats <= _gang.pointLimit;
        return _ProfileBuilderTile(
          profile: p,
          count: count,
          factionColor: factionColor,
          canAdd: canAdd,
          onIncrement: () => _increment(p),
          onDecrement: () => _decrement(p),
        );
      },
    );
  }
}

class _ProfileBuilderTile extends StatelessWidget {
  const _ProfileBuilderTile({
    required this.profile,
    required this.count,
    required this.factionColor,
    required this.canAdd,
    required this.onIncrement,
    required this.onDecrement,
  });

  final Profile profile;
  final int count;
  final Color factionColor;
  final bool canAdd;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final active = count > 0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: active
                ? factionColor.withOpacity(0.12)
                : _kCardBg.withOpacity(0.65),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: active ? factionColor.withOpacity(0.4) : Colors.white.withOpacity(0.3),
              width: active ? 1.0 : 0.5,
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
                          color: active ? factionColor : _kSubtleText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                _Counter(
                  count: count,
                  canAdd: canAdd,
                  onIncrement: onIncrement,
                  onDecrement: onDecrement,
                  activeColor: factionColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Counter extends StatelessWidget {
  const _Counter({
    required this.count,
    required this.canAdd,
    required this.onIncrement,
    required this.onDecrement,
    required this.activeColor,
  });

  final int count;
  final bool canAdd;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CircleButton(
          icon: Icons.remove,
          enabled: count > 0,
          color: activeColor,
          onTap: onDecrement,
        ),
        SizedBox(
          width: 32,
          child: Text(
            '$count',
            textAlign: TextAlign.center,
            style: GoogleFonts.cinzel(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: count > 0 ? activeColor : _kSubtleText.withOpacity(0.4),
            ),
          ),
        ),
        _CircleButton(
          icon: Icons.add,
          enabled: canAdd,
          color: activeColor,
          onTap: onIncrement,
        ),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.enabled,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled ? color.withOpacity(0.15) : Colors.transparent,
          border: Border.all(
            color: enabled ? color.withOpacity(0.5) : _kSubtleText.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled ? color : _kSubtleText.withOpacity(0.3),
        ),
      ),
    );
  }
}
