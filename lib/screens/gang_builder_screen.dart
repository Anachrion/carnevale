import 'dart:ui';
import '../app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/equipment.dart';
import '../models/gang.dart';
import '../models/profile.dart';
import '../services/equipment_service.dart';
import '../services/gang_service.dart';
import '../services/profile_service.dart';
import 'card_viewer_screen.dart';

const _kBackground = Color(0xFFF0EDE6);
const _kGold = Color(0xFFC4A050);

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

enum _Tab { list, hire }

enum _HireSort { role, name, cost }

class GangBuilderScreen extends StatefulWidget {
  const GangBuilderScreen({super.key, required this.gang});
  final Gang gang;

  @override
  State<GangBuilderScreen> createState() => _GangBuilderScreenState();
}

class _GangBuilderScreenState extends State<GangBuilderScreen> {
  late Gang _gang;
  List<Profile> _profiles = [];
  List<Equipment> _equipment = [];
  bool _loading = true;
  bool _busy = false;
  bool _errorsExpanded = true;
  _Tab _tab = _Tab.list;
  _HireSort _hireSort = _HireSort.role;
  bool _hireSortAsc = true;
  final _searchController = TextEditingController();

  List<Profile> get _filteredProfiles {
    final q = _searchController.text.trim().toLowerCase();
    final filtered = q.isEmpty
        ? List<Profile>.from(_profiles)
        : _profiles.where((p) => p.name.toLowerCase().contains(q)).toList();
    int roleRank(Profile p) {
      if (p.keywords.contains('Leader')) return 0;
      if (p.keywords.contains('Hero')) return 1;
      return 2;
    }

    filtered.sort((a, b) {
      final asc = _hireSortAsc;
      switch (_hireSort) {
        case _HireSort.cost:
          final c = a.ducats.compareTo(b.ducats);
          return asc ? c : -c;
        case _HireSort.name:
          final c = a.name.compareTo(b.name);
          return asc ? c : -c;
        case _HireSort.role:
          final rankCmp = roleRank(a).compareTo(roleRank(b));
          if (rankCmp != 0) return asc ? rankCmp : -rankCmp;
          final nameCmp = a.name.compareTo(b.name);
          return asc ? nameCmp : -nameCmp;
      }
    });
    return filtered;
  }

  @override
  void initState() {
    super.initState();
    _gang = widget.gang;
    _loadData();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final results = await Future.wait([
      ProfileService().search('', factions: {_gang.faction, 'gifted'}),
      EquipmentService().getAll(),
    ]);
    setState(() {
      _profiles = results[0] as List<Profile>;
      _equipment = results[1] as List<Equipment>;
      _loading = false;
    });
  }

  int _entryCount(Profile p) =>
      _gang.entries.where((e) => e.entryType == 'CardReference' && e.entryId == p.cardReferenceId).length;

  ListEntry? _entryFor(Profile p) {
    try {
      return _gang.entries.firstWhere((e) => e.entryType == 'CardReference' && e.entryId == p.cardReferenceId);
    } catch (_) {
      return null;
    }
  }

  Future<void> _add(Profile p) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final updated = await GangService().addEntry(_gang.id, p.cardReferenceId, 'CardReference');
      setState(() => _gang = updated);
    } finally {
      setState(() => _busy = false);
    }
  }

  Future<void> _addEquipment(Equipment e) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final updated = await GangService().addEntry(_gang.id, e.id, 'Equipment');
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

  Future<void> _removeEntry(ListEntry entry) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final updated = await GangService().removeEntry(_gang.id, entry.id);
      setState(() => _gang = updated);
    } finally {
      setState(() => _busy = false);
    }
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
                        style: GoogleFonts.cinzel(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${e.cost}',
                      style: GoogleFonts.cinzel(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _kGold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(color: Colors.white.withOpacity(0.2), thickness: 0.5),
                const SizedBox(height: 12),
                Text(
                  e.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.85),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _reorderEntry(int oldIndex, int newIndex) async {
    if (_busy) return;
    if (newIndex > oldIndex) newIndex--;
    if (newIndex == oldIndex) return;
    final entry = _gang.entries[oldIndex];
    final reordered = List<ListEntry>.from(_gang.entries)
      ..removeAt(oldIndex)
      ..insert(newIndex, entry);
    setState(() {
      _gang = Gang(
        id: _gang.id,
        name: _gang.name,
        faction: _gang.faction,
        points: _gang.points,
        totalCost: _gang.totalCost,
        selectionValid: _gang.selectionValid,
        selectionErrors: _gang.selectionErrors,
        entries: reordered,
      );
      _busy = true;
    });
    try {
      final updated = await GangService().reorderEntry(entry.id, newIndex + 1);
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
                    _buildHeader(context, factionColor),
                    _buildPointsBar(factionColor),
                    if (_gang.entries.isNotEmpty && !_gang.selectionValid)
                      _buildValidityPanel(),
                    const SizedBox(height: 12),
                    _buildTabBar(factionColor),
                    const SizedBox(height: 8),
                    Expanded(child: _buildTabContent(factionColor)),
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
            icon: Icon(Icons.arrow_back, color: context.textColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              _gang.name,
              style: GoogleFonts.cinzel(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: context.textColor,
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
    final remaining = limit - used;

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
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '$used',
                      style: GoogleFonts.cinzel(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isOver ? Colors.red.shade600 : context.textColor,
                      ),
                    ),
                    Text(
                      ' / $limit ducats',
                      style: GoogleFonts.cinzel(fontSize: 14, color: context.subtleTextColor),
                    ),
                    const Spacer(),
                    Text(
                      isOver ? '−${-remaining} left' : '$remaining left',
                      style: TextStyle(
                        fontSize: 12,
                        color: isOver ? Colors.red.shade400 : context.subtleTextColor,
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
                if (_gang.entries.isNotEmpty && _gang.selectionValid) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.check_circle_outline, size: 14, color: Colors.green.shade600),
                      const SizedBox(width: 6),
                      Text(
                        'Ready',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  static const _kAccentRed = Color(0xFFD04040);

  TextSpan _highlightNumbers(String text, TextStyle base) {
    final spans = <InlineSpan>[];
    final re = RegExp(r'\d+');
    int last = 0;
    for (final m in re.allMatches(text)) {
      if (m.start > last) {
        spans.add(TextSpan(text: text.substring(last, m.start), style: base));
      }
      spans.add(TextSpan(
        text: m.group(0),
        style: base.copyWith(color: _kAccentRed, fontWeight: FontWeight.w700),
      ));
      last = m.end;
    }
    if (last < text.length) {
      spans.add(TextSpan(text: text.substring(last), style: base));
    }
    return TextSpan(children: spans);
  }

  Widget _buildValidityPanel() {
    final errors = _gang.selectionErrors;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.38),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _kAccentRed.withOpacity(0.55), width: 1.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          color: _kAccentRed,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.warning_rounded, color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'List Invalid',
                              style: GoogleFonts.cinzel(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: _kAccentRed,
                                letterSpacing: 0.4,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Your list does not meet the guild's requirements.",
                              style: TextStyle(
                                fontSize: 12,
                                color: context.subtleTextColor,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _errorsExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          color: context.subtleTextColor,
                          size: 22,
                        ),
                        onPressed: () => setState(() => _errorsExpanded = !_errorsExpanded),
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                if (_errorsExpanded) ...[
                  Divider(height: 1, thickness: 0.5, color: _kAccentRed.withOpacity(0.3)),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
                    child: Column(
                      children: errors.map((e) {
                        final base = TextStyle(fontSize: 13, color: context.textColor, height: 1.4);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 7),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Container(
                                  width: 5,
                                  height: 5,
                                  decoration: const BoxDecoration(
                                    color: _kAccentRed,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: RichText(text: _highlightNumbers(e, base)),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(Color factionColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.35),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 0.5),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                _TabButton(
                  label: 'List',
                  selected: _tab == _Tab.list,
                  factionColor: factionColor,
                  onTap: () => setState(() => _tab = _Tab.list),
                ),
                _TabButton(
                  label: 'Hire',
                  selected: _tab == _Tab.hire,
                  factionColor: factionColor,
                  onTap: () => setState(() => _tab = _Tab.hire),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(Color factionColor) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: _kGold));
    }
    return _tab == _Tab.list
        ? _buildListTab(factionColor)
        : _buildHireTab(factionColor);
  }

  Widget _buildListTab(Color factionColor) {
    final entries = _gang.entries;
    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.group_outlined, size: 48, color: context.subtleTextColor.withOpacity(0.4)),
            const SizedBox(height: 12),
            Text(
              'No models hired yet',
              style: GoogleFonts.cinzel(fontSize: 15, color: context.subtleTextColor),
            ),
            const SizedBox(height: 6),
            Text(
              'Go to Hire to add models',
              style: TextStyle(fontSize: 12, color: context.subtleTextColor.withOpacity(0.7)),
            ),
          ],
        ),
      );
    }
    return ReorderableListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
      onReorder: _reorderEntry,
      proxyDecorator: (child, _, __) => child,
      buildDefaultDragHandles: false,
      itemCount: entries.length,
      itemBuilder: (_, i) {
        final entry = entries[i];
        final profileIdx = entry.entryType == 'CardReference'
            ? _profiles.indexWhere((p) => p.cardReferenceId == entry.entryId)
            : -1;
        final profile = profileIdx != -1 ? _profiles[profileIdx] : null;
        final equipmentItem = entry.entryType == 'Equipment'
            ? _equipment.where((e) => e.id == entry.entryId).firstOrNull
            : null;
        final entryColor = entry.entryType == 'Equipment'
            ? _kEquipmentColor
            : profile?.faction == 'gifted'
                ? (_kFactionColors['gifted'] ?? factionColor)
                : factionColor;
        final role = profile == null
            ? null
            : profile.keywords.contains('Leader')
                ? 'leader'
                : profile.keywords.contains('Hero')
                    ? 'hero'
                    : null;
        VoidCallback? onTap;
        if (profileIdx != -1) {
          onTap = () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CardViewerScreen(
                    profiles: _profiles,
                    initialIndex: profileIdx,
                  ),
                ),
              );
        } else if (equipmentItem != null) {
          onTap = () => _showEquipmentDetail(context, equipmentItem);
        }
        return ReorderableDragStartListener(
          key: ValueKey(entry.id),
          index: i,
          child: Padding(
            padding: EdgeInsets.only(bottom: i < entries.length - 1 ? 8 : 0),
            child: _EntryTile(
              entry: entry,
              factionColor: entryColor,
              role: role,
              busy: _busy,
              onRemove: () => _removeEntry(entry),
              onTap: onTap,
            ),
          ),
        );
      },
    );
  }

  Widget _buildHireTab(Color factionColor) {
    final profiles = _filteredProfiles;

    final factionProfiles = _gang.faction == 'gifted'
        ? profiles
        : profiles.where((p) => p.faction == _gang.faction).toList();
    final giftedProfiles = _gang.faction == 'gifted'
        ? <Profile>[]
        : profiles.where((p) => p.faction == 'gifted').toList();

    final hasLeader = _profiles.any(
      (p) => p.keywords.contains('Leader') && _entryCount(p) > 0,
    );

    Widget buildTile(Profile p) {
      final isUnique = p.keywords.contains('Unique');
      final isLeader = p.keywords.contains('Leader');
      final count = _entryCount(p);
      final alreadyHiredUnique = isUnique && count > 0;
      final leaderSlotTaken = isLeader && hasLeader && count == 0;
      final overBudget = _gang.totalCost + p.ducats > _gang.points;
      final greyOut = overBudget && !alreadyHiredUnique && !leaderSlotTaken;
      return _HireCardTile(
        profile: p,
        allProfiles: profiles,
        index: profiles.indexOf(p),
        count: count,
        isUnique: isUnique,
        factionColor: factionColor,
        canAdd: !alreadyHiredUnique && !leaderSlotTaken,
        greyOut: greyOut,
        busy: _busy,
        onAdd: () => _add(p),
        onRemove: () => _remove(p),
      );
    }

    return Column(
      children: [
        _buildHireControls(),
        Expanded(
          child: _profiles.isEmpty
              ? Center(
                  child: Text('No profiles for this faction.', style: TextStyle(color: context.subtleTextColor)),
                )
              : profiles.isEmpty
                  ? Center(
                      child: Text('No profiles match your search.', style: TextStyle(color: context.subtleTextColor)),
                    )
                  : CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                          sliver: SliverList.separated(
                            itemCount: factionProfiles.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 8),
                            itemBuilder: (_, i) => buildTile(factionProfiles[i]),
                          ),
                        ),
                        if (giftedProfiles.isNotEmpty) ...[
                          _buildHireDivider('Mercenaries'),
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            sliver: SliverList.separated(
                              itemCount: giftedProfiles.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 8),
                              itemBuilder: (_, i) => buildTile(giftedProfiles[i]),
                            ),
                          ),
                        ],
                        if (_equipment.isNotEmpty) ...[
                          _buildHireDivider('Equipment'),
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                            sliver: SliverList.separated(
                              itemCount: _equipment.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 8),
                              itemBuilder: (_, i) {
                                final e = _equipment[i];
                                final count = _gang.entries
                                    .where((en) => en.entryType == 'Equipment' && en.entryId == e.id)
                                    .length;
                                final canAdd = count == 0;
                                return _HireEquipmentTile(
                                  equipment: e,
                                  count: count,
                                  canAdd: canAdd,
                                  busy: _busy,
                                  onAdd: () => _addEquipment(e),
                                  onTap: () => _showEquipmentDetail(context, e),
                                );
                              },
                            ),
                          ),
                        ] else
                          const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
                      ],
                    ),
        ),
      ],
    );
  }

  SliverToBoxAdapter _buildHireDivider(String label) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Row(
            children: [
              Expanded(child: Divider(color: context.subtleTextColor.withOpacity(0.3), thickness: 0.5)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    color: context.subtleTextColor.withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              Expanded(child: Divider(color: context.subtleTextColor.withOpacity(0.3), thickness: 0.5)),
            ],
          ),
        ),
      );

  Widget _buildHireControls() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        children: [
          ClipRRect(
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
                  style: TextStyle(color: context.textColor, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Search profiles...',
                    hintStyle: TextStyle(color: context.subtleTextColor.withOpacity(0.7), fontSize: 15),
                    prefixIcon: const Icon(Icons.search, color: _kGold, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: context.subtleTextColor.withOpacity(0.6), size: 18),
                            onPressed: () => _searchController.clear(),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _SortChip(
                label: 'Role',
                selected: _hireSort == _HireSort.role,
                ascending: _hireSortAsc,
                onTap: () => setState(() {
                  if (_hireSort == _HireSort.role) {
                    _hireSortAsc = !_hireSortAsc;
                  } else {
                    _hireSort = _HireSort.role;
                    _hireSortAsc = true;
                  }
                }),
              ),
              const SizedBox(width: 6),
              _SortChip(
                label: 'Name',
                selected: _hireSort == _HireSort.name,
                ascending: _hireSortAsc,
                onTap: () => setState(() {
                  if (_hireSort == _HireSort.name) {
                    _hireSortAsc = !_hireSortAsc;
                  } else {
                    _hireSort = _HireSort.name;
                    _hireSortAsc = true;
                  }
                }),
              ),
              const SizedBox(width: 6),
              _SortChip(
                label: 'Cost',
                selected: _hireSort == _HireSort.cost,
                ascending: _hireSortAsc,
                onTap: () => setState(() {
                  if (_hireSort == _HireSort.cost) {
                    _hireSortAsc = !_hireSortAsc;
                  } else {
                    _hireSort = _HireSort.cost;
                    _hireSortAsc = true;
                  }
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({
    required this.label,
    required this.selected,
    required this.ascending,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool ascending;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? _kGold.withOpacity(0.85) : Colors.white.withOpacity(0.35),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? _kGold : Colors.white.withOpacity(0.4),
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
                ascending ? Icons.arrow_upward : Icons.arrow_downward,
                size: 10,
                color: Colors.white,
              ),
            ],
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
    required this.factionColor,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color factionColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? factionColor : Colors.transparent,
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

class _EntryTile extends StatefulWidget {
  const _EntryTile({
    required this.entry,
    required this.factionColor,
    required this.busy,
    required this.onRemove,
    this.role,
    this.onTap,
  });

  final ListEntry entry;
  final Color factionColor;
  final String? role;
  final bool busy;
  final VoidCallback onRemove;
  final VoidCallback? onTap;

  @override
  State<_EntryTile> createState() => _EntryTileState();
}

class _EntryTileState extends State<_EntryTile> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;
  late final Animation<double> _size;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 320));
    _slide = Tween(begin: Offset.zero, end: const Offset(1.2, 0)).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.7, curve: Curves.easeIn)),
    );
    _fade = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.65, curve: Curves.easeIn)),
    );
    _size = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.55, 1.0, curve: Curves.easeInOut)),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _handleRemove() {
    _ctrl.forward().then((_) => widget.onRemove());
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _size,
      axisAlignment: -1,
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: _slide,
          child: GestureDetector(
            onTap: widget.onTap,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.factionColor,
                      Color.lerp(widget.factionColor, Colors.black, 0.45)!,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Flexible(
                              child: Text(
                                widget.entry.name,
                                style: GoogleFonts.cinzel(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (widget.role != null) ...[
                              const SizedBox(width: 6),
                              Text(
                                widget.role!,
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
                      const SizedBox(width: 8),
                      Text(
                        '${widget.entry.cost}',
                        style: GoogleFonts.cinzel(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: widget.busy ? null : _handleRemove,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.15),
                            border: Border.all(color: Colors.white.withOpacity(0.3), width: 0.5),
                          ),
                          child: Icon(Icons.remove, size: 14, color: Colors.white.withOpacity(0.85)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HireCardTile extends StatelessWidget {
  const _HireCardTile({
    required this.profile,
    required this.allProfiles,
    required this.index,
    required this.count,
    required this.isUnique,
    required this.factionColor,
    required this.canAdd,
    required this.greyOut,
    required this.busy,
    required this.onAdd,
    required this.onRemove,
  });

  final Profile profile;
  final List<Profile> allProfiles;
  final int index;
  final int count;
  final bool isUnique;
  final Color factionColor;
  final bool canAdd;
  final bool greyOut;
  final bool busy;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final inList = count > 0;
    final base = _kFactionColors[profile.faction] ?? factionColor;
    final bgColor = inList
        ? Color.lerp(base, Colors.black, 0.45)!
        : greyOut
            ? Color.lerp(base, Colors.white, 0.28)!
            : base;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CardViewerScreen(profiles: allProfiles, initialIndex: index),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 12, 14, 12),
            child: Row(
              children: [
                _HireToggleButton(
                  canAdd: canAdd,
                  busy: busy,
                  onAdd: onAdd,
                ),
                const SizedBox(width: 12),
                Expanded(
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
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
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
                      if (inList)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isUnique ? 'Hired' : '×$count',
                            style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w600),
                          ),
                        ),
                      const SizedBox(width: 8),
                      Text(
                        '${profile.ducats}',
                        style: GoogleFonts.cinzel(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (inList)
                        GestureDetector(
                          onTap: busy ? null : onRemove,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.15),
                              border: Border.all(color: Colors.white.withOpacity(0.3), width: 0.5),
                            ),
                            child: Icon(Icons.remove, size: 14, color: Colors.white.withOpacity(0.85)),
                          ),
                        )
                      else
                        const SizedBox(width: 28),
                    ],
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

class _HireToggleButton extends StatelessWidget {
  const _HireToggleButton({
    required this.canAdd,
    required this.busy,
    required this.onAdd,
  });

  final bool canAdd;
  final bool busy;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    if (busy) {
      return const SizedBox(
        width: 32, height: 32,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      );
    }
    if (!canAdd) return SizedBox(
      width: 32,
      height: 32,
      child: Icon(Icons.block, size: 28, color: Colors.white.withOpacity(0.30)),
    );
    return GestureDetector(
      onTap: onAdd,
      child: Container(
        width: 32, height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.2),
          border: Border.all(color: Colors.white.withOpacity(0.5)),
        ),
        child: const Icon(Icons.add, size: 16, color: Colors.white),
      ),
    );
  }
}

const _kEquipmentColor = Color(0xFF4A3F35);

class _HireEquipmentTile extends StatelessWidget {
  const _HireEquipmentTile({
    required this.equipment,
    required this.count,
    required this.canAdd,
    required this.busy,
    required this.onAdd,
    required this.onTap,
  });

  final Equipment equipment;
  final int count;
  final bool canAdd;
  final bool busy;
  final VoidCallback onAdd;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final inList = count > 0;
    final bgColor = inList
        ? Color.lerp(_kEquipmentColor, Colors.black, 0.35)!
        : canAdd
            ? _kEquipmentColor
            : Color.lerp(_kEquipmentColor, Colors.white, 0.28)!;
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 12, 14, 12),
          child: Row(
            children: [
              _HireToggleButton(canAdd: canAdd, busy: busy, onAdd: onAdd),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  equipment.name,
                  style: GoogleFonts.cinzel(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (inList) ...[
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '×$count',
                    style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w600),
                  ),
                ),
              ],
              const SizedBox(width: 8),
              Text(
                '${equipment.cost}',
                style: GoogleFonts.cinzel(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
