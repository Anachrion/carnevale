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
import '../widgets/spell_chips.dart';
import '../widgets/themed_dialog_card.dart';
import 'card_viewer_screen.dart';

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
  List<Spell> _spells = [];
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
    final results = await Future.wait([
      ProfileService().search('', factions: {_gang.faction, 'gifted'}),
      EquipmentService().getAll(),
      GangService().loadSpells(),
    ]);
    setState(() {
      _profiles = results[0] as List<Profile>;
      _equipment = results[1] as List<Equipment>;
      _spells = results[2] as List<Spell>;
      _loading = false;
    });
  }

  Future<void> _editSpells(ListEntry entry) async {
    if (_busy) return;
    final result = await showDialog<_SpellSelection>(
      context: context,
      builder: (_) => _SpellPickerDialog(entry: entry, allSpells: _spells),
    );
    if (result == null) return;
    setState(() => _busy = true);
    try {
      final updated = await GangService().setEntrySpells(entry.id, result.discipline, result.spellIds);
      setState(() => _gang = updated);
    } finally {
      setState(() => _busy = false);
    }
  }

  int _entryCount(Profile p) =>
      _gang.entries.where((e) => e.entryType == 'CardReference' && p.cardReferenceIds.contains(e.entryId)).length;

  ListEntry? _entryFor(Profile p) {
    try {
      return _gang.entries.firstWhere((e) => e.entryType == 'CardReference' && p.cardReferenceIds.contains(e.entryId));
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
      builder: (context) => ThemedDialogCard(
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
                      color: context.textColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${e.cost}',
                  style: GoogleFonts.cinzel(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppPalette.gold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(color: context.subtleTextColor.withOpacity(0.3), thickness: 0.5),
            const SizedBox(height: 12),
            Text(
              e.description,
              style: TextStyle(
                fontSize: 13,
                color: context.textColor,
                height: 1.5,
              ),
            ),
          ],
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
    final factionColor = AppPalette.factionColors[_gang.faction] ?? AppPalette.gold;
    return Scaffold(
      backgroundColor: AppPalette.background,
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
    final iconPath = AppPalette.factionIcons[_gang.faction];
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
    final barColor = isOver ? Colors.red.shade400 : AppPalette.gold;
    final remaining = limit - used;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              gradient: context.panelGradient,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: context.panelBorderColor,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

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
        style: base.copyWith(fontWeight: FontWeight.w700),
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
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppPalette.brightRed,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: errors.map((e) {
            final base = TextStyle(fontSize: 12, color: Colors.white, height: 1.4);
            return Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 9),
                  Expanded(child: RichText(text: _highlightNumbers(e, base))),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTabBar(Color factionColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              gradient: context.panelGradient,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: context.panelBorderColor,
                width: 1.0,
              ),
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
      return const Center(child: CircularProgressIndicator(color: AppPalette.gold));
    }
    return IndexedStack(
      index: _tab == _Tab.list ? 0 : 1,
      children: [
        _buildListTab(factionColor),
        _buildHireTab(factionColor),
      ],
    );
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
    final hiredProfiles = entries
        .where((e) => e.entryType == 'CardReference')
        .map((e) => _profiles.where((p) => p.cardReferenceIds.contains(e.entryId)).firstOrNull)
        .whereType<Profile>()
        .toList();
    return ReorderableListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
      onReorder: _reorderEntry,
      proxyDecorator: (child, _, __) => child,
      buildDefaultDragHandles: false,
      itemCount: entries.length,
      itemBuilder: (_, i) {
        final entry = entries[i];
        final profileIdx = entry.entryType == 'CardReference'
            ? _profiles.indexWhere((p) => p.cardReferenceIds.contains(entry.entryId))
            : -1;
        final profile = profileIdx != -1 ? _profiles[profileIdx] : null;
        final equipmentItem = entry.entryType == 'Equipment'
            ? _equipment.where((e) => e.id == entry.entryId).firstOrNull
            : null;
        final entryColor = entry.entryType == 'Equipment'
            ? AppPalette.equipment
            : profile?.faction == 'gifted'
                ? (AppPalette.factionColors['gifted'] ?? factionColor)
                : factionColor;
        final role = profile == null
            ? null
            : profile.keywords.contains('Leader')
                ? 'leader'
                : profile.keywords.contains('Hero')
                    ? 'hero'
                    : null;
        VoidCallback? onTap;
        if (profile != null) {
          final hiredIndex = hiredProfiles.indexWhere((p) => p.cardReferenceId == profile.cardReferenceId);
          onTap = () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CardViewerScreen(
                    profiles: hiredProfiles,
                    initialIndex: hiredIndex,
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
              onEditSpells: entry.mage ? () => _editSpells(entry) : null,
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
      return _HireCardTile(
        profile: p,
        allProfiles: profiles,
        index: profiles.indexOf(p),
        count: count,
        isUnique: isUnique,
        factionColor: factionColor,
        canAdd: !alreadyHiredUnique && !leaderSlotTaken,
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
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Container(
                decoration: BoxDecoration(
                  gradient: context.panelGradient,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: context.panelBorderColor,
                    width: 1.0,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: context.textColor, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Search profiles...',
                    hintStyle: TextStyle(color: context.subtleTextColor.withOpacity(0.7), fontSize: 15),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppPalette.gold
                          : AppPalette.red,
                      size: 20,
                    ),
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
    final accent = Theme.of(context).brightness == Brightness.dark
        ? AppPalette.gold
        : AppPalette.red;
    return GestureDetector(
      onTap: onTap,
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
    this.onEditSpells,
  });

  final ListEntry entry;
  final Color factionColor;
  final String? role;
  final bool busy;
  final VoidCallback onRemove;
  final VoidCallback? onTap;
  // Non-null only for Mage models; opens the spell picker for this model (rulebook p24).
  final VoidCallback? onEditSpells;

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    Row(
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
                  if (widget.onEditSpells != null) _buildSpellRow(),
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

  Widget _buildSpellRow() {
    final entry = widget.entry;
    final chips = spellChipsFor(entry);
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _spellsButton(),
          if (chips.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'No spells',
                style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.6), fontStyle: FontStyle.italic),
              ),
            )
          else
            ...chips,
        ],
      ),
    );
  }

  Widget _spellsButton() {
    return GestureDetector(
      onTap: widget.busy ? null : widget.onEditSpells,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.35), width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_fix_high, size: 12, color: Colors.white.withOpacity(0.9)),
            const SizedBox(width: 5),
            Text(
              'Spells',
              style: GoogleFonts.cinzel(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 0.5),
            ),
          ],
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
  final bool busy;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final inList = count > 0;
    final base = AppPalette.factionColors[profile.faction] ?? factionColor;
    final bgColor = inList ? Color.lerp(base, Colors.black, 0.45)! : base;
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
        ? Color.lerp(AppPalette.equipment, Colors.black, 0.35)!
        : canAdd
            ? AppPalette.equipment
            : Color.lerp(AppPalette.equipment, Colors.white, 0.28)!;
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

/// The result of the spell picker: the committed Discipline and the chosen non-Cantrip spell ids.
class _SpellSelection {
  final String? discipline;
  final List<int> spellIds;
  const _SpellSelection(this.discipline, this.spellIds);
}

class _SpellPickerDialog extends StatefulWidget {
  const _SpellPickerDialog({required this.entry, required this.allSpells});

  final ListEntry entry;
  final List<Spell> allSpells;

  @override
  State<_SpellPickerDialog> createState() => _SpellPickerDialogState();
}

class _SpellPickerDialogState extends State<_SpellPickerDialog> {
  String? _discipline;
  late Set<int> _selected;

  @override
  void initState() {
    super.initState();
    final disciplines = widget.entry.disciplines;
    // Default to the model's committed Discipline, or the only one it has access to.
    _discipline = widget.entry.spellDiscipline ?? (disciplines.length == 1 ? disciplines.first : null);
    _selected = widget.entry.spells.where((s) => !s.cantrip).map((s) => s.id).toSet();
  }

  List<Spell> get _choosable =>
      widget.allSpells.where((s) => s.discipline == _discipline && !s.cantrip).toList()
        ..sort((a, b) => a.name.compareTo(b.name));

  Spell? get _cantrip {
    try {
      return widget.allSpells.firstWhere((s) => s.discipline == _discipline && s.cantrip);
    } catch (_) {
      return null;
    }
  }

  int get _slots => widget.entry.spellSlots;

  void _selectDiscipline(String slug) {
    if (slug == _discipline) return;
    // Spells must all share one Discipline (rulebook p24), so switching clears the picks.
    setState(() {
      _discipline = slug;
      _selected = {};
    });
  }

  void _toggle(Spell spell) {
    setState(() {
      if (_selected.contains(spell.id)) {
        _selected.remove(spell.id);
      } else if (_selected.length < _slots) {
        _selected.add(spell.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final disciplines = widget.entry.disciplines;
    final accent = Theme.of(context).brightness == Brightness.dark ? AppPalette.gold : AppPalette.red;
    return ThemedDialogCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.entry.name,
            style: GoogleFonts.cinzel(fontSize: 16, fontWeight: FontWeight.w700, color: context.textColor),
          ),
          const SizedBox(height: 2),
          Text(
            'Spells known — ${_selected.length}/$_slots',
            style: TextStyle(fontSize: 12, color: context.subtleTextColor),
          ),
          const SizedBox(height: 14),
          if (disciplines.length > 1) ...[
            Text(
              'Discipline',
              style: TextStyle(fontSize: 11, color: context.subtleTextColor, fontWeight: FontWeight.w600, letterSpacing: 0.5),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: disciplines.map((slug) {
                final selected = slug == _discipline;
                return GestureDetector(
                  onTap: () => _selectDiscipline(slug),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected ? accent.withOpacity(0.85) : Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: selected ? accent : context.subtleTextColor.withOpacity(0.3), width: 0.5),
                    ),
                    child: Text(
                      disciplineLabel(slug),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                        color: selected ? Colors.white : context.textColor,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
          ] else if (disciplines.length == 1) ...[
            Text(
              'Discipline: ${disciplineLabel(disciplines.first)}',
              style: TextStyle(fontSize: 12, color: context.textColor, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
          ],
          if (_discipline == null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text('Pick a Discipline to choose spells.', style: TextStyle(color: context.subtleTextColor, fontSize: 13)),
              ),
            )
          else
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_cantrip != null)
                      _SpellRow(
                        spell: _cantrip!,
                        checked: true,
                        enabled: false,
                        trailingLabel: 'always known',
                        onTap: null,
                      ),
                    ..._choosable.map((spell) {
                      final checked = _selected.contains(spell.id);
                      final enabled = checked || _selected.length < _slots;
                      return _SpellRow(
                        spell: spell,
                        checked: checked,
                        enabled: enabled,
                        onTap: enabled ? () => _toggle(spell) : null,
                      );
                    }),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel', style: TextStyle(color: context.subtleTextColor)),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: accent, foregroundColor: Colors.white),
                onPressed: () => Navigator.of(context).pop(_SpellSelection(_discipline, _selected.toList())),
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SpellRow extends StatelessWidget {
  const _SpellRow({
    required this.spell,
    required this.checked,
    required this.enabled,
    this.trailingLabel,
    this.onTap,
  });

  final Spell spell;
  final bool checked;
  final bool enabled;
  final String? trailingLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).brightness == Brightness.dark ? AppPalette.gold : AppPalette.red;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              checked ? Icons.check_circle : Icons.circle_outlined,
              size: 20,
              color: checked ? accent : context.subtleTextColor.withOpacity(enabled ? 0.6 : 0.25),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          spell.name,
                          style: GoogleFonts.cinzel(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: enabled ? context.textColor : context.subtleTextColor,
                          ),
                        ),
                      ),
                      if (trailingLabel != null)
                        Text(
                          trailingLabel!,
                          style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: context.subtleTextColor),
                        )
                      else
                        Text(
                          'WP ${spell.cost} · Diff ${spell.difficulty}',
                          style: TextStyle(fontSize: 10, color: context.subtleTextColor),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    spell.description,
                    style: TextStyle(fontSize: 11, color: context.subtleTextColor, height: 1.35),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
