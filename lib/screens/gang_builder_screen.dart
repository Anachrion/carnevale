import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/gang.dart';
import '../models/gang_validation.dart';
import '../models/profile.dart';
import '../services/gang_service.dart';
import '../services/profile_service.dart';
import 'card_viewer_screen.dart';

const _kBackground = Color(0xFFF0EDE6);
const _kDarkText = Color(0xFF2C2418);
const _kGold = Color(0xFFC4A050);
const _kSubtleText = Color(0xFF7A6E62);

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
  bool _loading = true;
  bool _busy = false;
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
    final profiles = await ProfileService().search('', factions: {_gang.faction, 'gifted'});
    setState(() {
      _profiles = profiles;
      _loading = false;
    });
  }

  int _entryCount(Profile p) =>
      _gang.entries.where((e) => e.referenceId == p.cardReferenceId).length;

  ListEntry? _entryFor(Profile p) {
    try {
      return _gang.entries.firstWhere((e) => e.referenceId == p.cardReferenceId);
    } catch (_) {
      return null;
    }
  }

  Future<void> _add(Profile p) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final updated = await GangService().addEntry(_gang.id, p.cardReferenceId);
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
            Icon(Icons.group_outlined, size: 48, color: _kSubtleText.withOpacity(0.4)),
            const SizedBox(height: 12),
            Text(
              'No models hired yet',
              style: GoogleFonts.cinzel(fontSize: 15, color: _kSubtleText),
            ),
            const SizedBox(height: 6),
            Text(
              'Go to Hire to add models',
              style: TextStyle(fontSize: 12, color: _kSubtleText.withOpacity(0.7)),
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
        final profileIdx = _profiles.indexWhere((p) => p.cardReferenceId == entry.referenceId);
        final profile = profileIdx != -1 ? _profiles[profileIdx] : null;
        final entryColor = profile?.faction == 'gifted'
            ? (_kFactionColors['gifted'] ?? factionColor)
            : factionColor;
        final role = profile == null
            ? null
            : profile.keywords.contains('Leader')
                ? 'leader'
                : profile.keywords.contains('Hero')
                    ? 'hero'
                    : null;
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
            onTap: profileIdx == -1
                ? null
                : () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CardViewerScreen(
                          profiles: _profiles,
                          initialIndex: profileIdx,
                        ),
                      ),
                    ),
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

    Widget buildTile(Profile p) {
      final isUnique = p.keywords.contains('Unique');
      final count = _entryCount(p);
      final validation = GangValidator.canAdd(_gang, p);
      final overBudget = _gang.totalCost + p.ducats > _gang.points;
      final greyOut = overBudget && !(isUnique && count > 0);
      return _HireCardTile(
        profile: p,
        allProfiles: profiles,
        index: profiles.indexOf(p),
        count: count,
        isUnique: isUnique,
        factionColor: factionColor,
        canAdd: validation.valid,
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
                  child: Text('No profiles for this faction.', style: TextStyle(color: _kSubtleText)),
                )
              : profiles.isEmpty
                  ? Center(
                      child: Text('No profiles match your search.', style: TextStyle(color: _kSubtleText)),
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
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                              child: Row(
                                children: [
                                  Expanded(child: Divider(color: _kSubtleText.withOpacity(0.3), thickness: 0.5)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Text(
                                      'Mercenaries',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: _kSubtleText.withOpacity(0.7),
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Divider(color: _kSubtleText.withOpacity(0.3), thickness: 0.5)),
                                ],
                              ),
                            ),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                            sliver: SliverList.separated(
                              itemCount: giftedProfiles.length,
                              separatorBuilder: (_, __) => const SizedBox(height: 8),
                              itemBuilder: (_, i) => buildTile(giftedProfiles[i]),
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
                  style: const TextStyle(color: _kDarkText, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Search profiles...',
                    hintStyle: TextStyle(color: _kSubtleText.withOpacity(0.7), fontSize: 15),
                    prefixIcon: const Icon(Icons.search, color: _kGold, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear, color: _kSubtleText.withOpacity(0.6), size: 18),
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
                color: selected ? Colors.white : _kSubtleText,
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
              color: selected ? Colors.white : _kSubtleText,
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
