import 'dart:ui';
import '../app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/equipment.dart';
import '../models/gang.dart';
import '../models/profile.dart';
import '../services/equipment_service.dart';
import '../services/game_service.dart';
import '../services/profile_service.dart';
import 'card_viewer_screen.dart';

const _kGold = Color(0xFFC4A050);
const _kEquipmentColor = Color(0xFF4A3F35);

const _kHpPillColors = [ Color(0x998A3434), Color(0x994A1414) ];
const _kWpPillColors = [ Color(0x99428DF5), Color(0x9914244A) ];
const _kCpPillColors = [ Color(0x9911B84E), Color(0x9914381C) ];

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

/// Read-only view of both players' gangs for a game once each has picked one — reuses the
/// gang builder's visual language (faction colors, entry tiles, tap-to-view-card) but with no
/// hire/reorder/remove actions, since gang lists are frozen for the game the moment selected.
class GameGangsScreen extends StatelessWidget {
  const GameGangsScreen({
    super.key,
    required this.gameId,
    required this.myPlayerId,
    required this.myLabel,
    required this.opponentPlayerId,
    required this.opponentLabel,
  });

  final int gameId;
  final int myPlayerId;
  final String myLabel;
  final int opponentPlayerId;
  final String opponentLabel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    const SizedBox(height: 8),
                    Expanded(
                      child: GangsTabView(
                        gameId: gameId,
                        myPlayerId: myPlayerId,
                        myLabel: myLabel,
                        opponentPlayerId: opponentPlayerId,
                        opponentLabel: opponentLabel,
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: context.textColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'Gangs',
              style: GoogleFonts.cinzel(fontSize: 20, fontWeight: FontWeight.w700, color: context.textColor, letterSpacing: 2),
            ),
          ),
        ],
      ),
    );
  }
}

/// The my-gang/opponent-gang tab pair, split out of [GameGangsScreen] so it can also be embedded
/// directly as a game phase's body (e.g. once a game goes in_progress) without a second Scaffold
/// or app bar on top of the one the host screen already provides.
class GangsTabView extends StatelessWidget {
  const GangsTabView({
    super.key,
    required this.gameId,
    required this.myPlayerId,
    required this.myLabel,
    required this.opponentPlayerId,
    required this.opponentLabel,
  });

  final int gameId;
  final int myPlayerId;
  final String myLabel;
  final int opponentPlayerId;
  final String opponentLabel;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          _buildTabBar(context),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              children: [
                _GangTab(gameId: gameId, playerId: myPlayerId),
                _GangTab(gameId: gameId, playerId: opponentPlayerId),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        labelColor: _kGold,
        unselectedLabelColor: context.subtleTextColor,
        indicatorColor: _kGold,
        labelStyle: GoogleFonts.cinzel(fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 1),
        tabs: [
          Tab(text: myLabel),
          Tab(text: opponentLabel),
        ],
      ),
    );
  }
}

class _GangTabData {
  const _GangTabData({required this.gang, required this.profiles, required this.equipment});
  final Gang gang;
  final List<Profile> profiles;
  final List<Equipment> equipment;
}

class _GangTab extends StatefulWidget {
  const _GangTab({required this.gameId, required this.playerId});

  final int gameId;
  final int playerId;

  @override
  State<_GangTab> createState() => _GangTabState();
}

class _GangTabState extends State<_GangTab> with AutomaticKeepAliveClientMixin {
  late Future<_GangTabData> _future;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_GangTabData> _load() async {
    final gang = await GameService().playerList(widget.gameId, widget.playerId);
    final results = await Future.wait([
      ProfileService().search('', factions: {gang.faction, 'gifted'}),
      EquipmentService().getAll(),
    ]);
    return _GangTabData(
      gang: gang,
      profiles: results[0] as List<Profile>,
      equipment: results[1] as List<Equipment>,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<_GangTabData>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Could not load this gang.', style: TextStyle(color: context.subtleTextColor)),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator(color: _kGold));
        }
        final data = snapshot.data!;
        return _ReadOnlyGangBody(gang: data.gang, profiles: data.profiles, equipment: data.equipment);
      },
    );
  }
}

class _ReadOnlyGangBody extends StatelessWidget {
  const _ReadOnlyGangBody({required this.gang, required this.profiles, required this.equipment});

  final Gang gang;
  final List<Profile> profiles;
  final List<Equipment> equipment;

  @override
  Widget build(BuildContext context) {
    final factionColor = _kFactionColors[gang.faction] ?? _kGold;
    return Column(
      children: [
        _buildGangHeader(context, factionColor),
        _buildPointsBar(context, factionColor),
        const SizedBox(height: 12),
        Expanded(child: _buildEntries(context, factionColor)),
      ],
    );
  }

  Widget _buildGangHeader(BuildContext context, Color factionColor) {
    final iconPath = _kFactionIcons[gang.faction];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              gang.name,
              style: GoogleFonts.cinzel(fontSize: 18, fontWeight: FontWeight.w700, color: context.textColor, letterSpacing: 1),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: factionColor, shape: BoxShape.circle),
            padding: const EdgeInsets.all(6),
            child: iconPath != null
                ? Image.asset(iconPath, fit: BoxFit.contain, color: Colors.white, colorBlendMode: BlendMode.srcIn)
                : const Icon(Icons.flag, color: Colors.white, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsBar(BuildContext context, Color factionColor) {
    final used = gang.totalCost;
    final limit = gang.points;
    final ratio = limit > 0 ? (used / limit).clamp(0.0, 1.0) : 0.0;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              gradient: isDark
                  ? const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x10000000), Color(0x88000000)],
                    )
                  : LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFFF5F2EE).withOpacity(0.30),
                        const Color(0xFFF5F2EE).withOpacity(0.75),
                      ],
                    ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? const Color(0xFFB1986C).withOpacity(0.45) : Colors.white.withOpacity(0.3),
                width: 1.0,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text('$used', style: GoogleFonts.cinzel(fontSize: 18, fontWeight: FontWeight.w700, color: context.textColor)),
                    Text(' / $limit ducats', style: GoogleFonts.cinzel(fontSize: 13, color: context.subtleTextColor)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: ratio,
                    backgroundColor: Colors.black.withOpacity(0.08),
                    valueColor: AlwaysStoppedAnimation(factionColor),
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

  Widget _buildEntries(BuildContext context, Color factionColor) {
    final entries = gang.entries;
    if (entries.isEmpty) {
      return Center(
        child: Text('No models hired.', style: GoogleFonts.cinzel(fontSize: 14, color: context.subtleTextColor)),
      );
    }
    final hiredProfiles = entries
        .where((e) => e.entryType == 'CardReference')
        .map((e) => profiles.where((p) => p.cardReferenceId == e.entryId).firstOrNull)
        .whereType<Profile>()
        .toList();
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
      itemCount: entries.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final entry = entries[i];
        final profile = entry.entryType == 'CardReference'
            ? profiles.where((p) => p.cardReferenceId == entry.entryId).firstOrNull
            : null;
        final equipmentItem = entry.entryType == 'Equipment'
            ? equipment.where((e) => e.id == entry.entryId).firstOrNull
            : null;
        final entryColor = entry.entryType == 'Equipment'
            ? _kEquipmentColor
            : profile?.faction == 'gifted'
                ? (_kFactionColors['gifted'] ?? factionColor)
                : factionColor;
        VoidCallback? onTap;
        if (profile != null) {
          final hiredIndex = hiredProfiles.indexWhere((p) => p.cardReferenceId == profile.cardReferenceId);
          onTap = () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CardViewerScreen(profiles: hiredProfiles, initialIndex: hiredIndex),
                ),
              );
        } else if (equipmentItem != null) {
          onTap = () => _showEquipmentDetail(context, equipmentItem);
        }
        return _ReadOnlyEntryTile(entry: entry, color: entryColor, onTap: onTap);
      },
    );
  }

  void _showEquipmentDetail(BuildContext context, Equipment e) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: const BoxDecoration(
              color: _kEquipmentColor,
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        e.name,
                        style: GoogleFonts.cinzel(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${e.cost}',
                      style: GoogleFonts.cinzel(fontSize: 16, fontWeight: FontWeight.w700, color: _kGold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(color: Colors.white.withOpacity(0.2), thickness: 0.5),
                const SizedBox(height: 12),
                Text(
                  e.description,
                  style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.85), height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReadOnlyEntryTile extends StatelessWidget {
  const _ReadOnlyEntryTile({required this.entry, required this.color, this.onTap});

  final ListEntry entry;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final state = entry.state;
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, Color.lerp(color, Colors.black, 0.45)!],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.name,
                      style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${entry.cost}',
                    style: GoogleFonts.cinzel(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ],
              ),
              if (state != null) ...[
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          _StatPill(label: 'HP', value: state.lifePoints, colors: _kHpPillColors),
                          _StatPill(label: 'WP', value: state.willPoints, colors: _kWpPillColors),
                          _StatPill(label: 'CP', value: state.commandPoints, colors: _kCpPillColors),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 6,
                      children: _counterIcons(state),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Always shows all five counters (dimmed when inactive) rather than only the active ones, so
  // every tile has the same fixed layout — easier to scan across a whole gang, and leaves room
  // to become tap targets once in-round editing lands.
  List<Widget> _counterIcons(EntryState state) {
    return [
      _CounterIcon(asset: 'assets/images/counters/stunned.png', label: 'Stunned', active: state.stunned),
      _CounterIcon(asset: 'assets/images/counters/hidden.png', label: 'Hidden', active: state.hidden),
      _CounterIcon(asset: 'assets/images/counters/guard.png', label: 'Guarding', active: state.guarding),
      _CounterIcon(asset: 'assets/images/counters/carry_objective.png', label: 'Carrying objective', active: state.carryingObjective),
      _CounterIcon(
        asset: 'assets/images/counters/underwater_counter.png',
        label: 'Underwater',
        active: state.underwaterCounters > 0,
        badge: state.underwaterCounters > 0 ? state.underwaterCounters : null,
      ),
    ];
  }
}

/// Compact "HP 6/10"-style pill: current value first, starting value after the slash — matches
/// the "A/B" shorthand used at the table (A = remaining, B = starting).
class _StatPill extends StatelessWidget {
  const _StatPill({required this.label, required this.value, required this.colors});

  final String label;
  final EntryStatValue value;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors, begin: Alignment.centerLeft, end: Alignment.centerRight),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label ${value.current}/${value.starting}',
        style: GoogleFonts.cinzel(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
      ),
    );
  }
}

/// A single status counter icon (stunned/hidden/guarding/carrying objective/underwater), always
/// rendered so tile layouts stay consistent — full opacity with a gold ring when the counter is
/// active, dimmed with no ring when it isn't. Underwater additionally carries a count badge (it
/// stacks up to 2, unlike the other four, which are simple on/off flags).
class _CounterIcon extends StatelessWidget {
  const _CounterIcon({required this.asset, required this.label, required this.active, this.badge});

  final String asset;
  final String label;
  final bool active;
  final int? badge;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: active ? _kGold.withOpacity(0.35) : Colors.black.withOpacity(0.2),
          shape: BoxShape.circle,
          border: active ? Border.all(color: _kGold, width: 1.4) : null,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Opacity(
              opacity: active ? 1.0 : 0.35,
              child: Image.asset(asset, width: 26, height: 26, color: Colors.white, colorBlendMode: BlendMode.srcIn),
            ),
            if (badge != null)
              Positioned(
                right: -4,
                bottom: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(color: _kGold, borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    '$badge',
                    style: GoogleFonts.cinzel(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.black),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
