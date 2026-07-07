import '../app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import '../models/profile.dart';
import '../services/equipment_service.dart';
import '../services/gang_service.dart';
import '../services/profile_service.dart';
import '../widgets/app_background.dart';
import '../widgets/equipment_detail.dart';
import '../widgets/faction_badge.dart';
import '../widgets/glass_panel.dart';
import '../widgets/points_bar.dart';
import '../widgets/sort_chip.dart';
import '../widgets/spell_chips.dart';
import '../widgets/themed_dialog_card.dart';
import 'card_viewer_screen.dart';

part 'gang_builder_tiles.dart';
part 'gang_builder_spell_picker.dart';

enum _Tab { list, hire }

enum _HireSort { role, name, cost }

class GangBuilderScreen extends StatefulWidget {
  const GangBuilderScreen({super.key, required this.gang});
  final api.ModelList gang;

  @override
  State<GangBuilderScreen> createState() => _GangBuilderScreenState();
}

class _GangBuilderScreenState extends State<GangBuilderScreen> {
  late api.ModelList _gang;
  List<api.Profile> _profiles = [];
  List<api.Equipment> _equipment = [];
  List<api.Spell> _spells = [];
  bool _loading = true;
  bool _busy = false;
  _Tab _tab = _Tab.list;
  _HireSort _hireSort = _HireSort.role;
  bool _hireSortAsc = true;
  final _searchController = TextEditingController();

  // Cached filtered+sorted hire list. Recomputed only when its inputs (search text, sort field/dir,
  // or the loaded profiles) change — not on every rebuild, which the old getter did (F-P3-6).
  List<api.Profile> _visibleProfiles = [];

  void _recomputeVisibleProfiles() {
    final q = _searchController.text.trim().toLowerCase();
    final filtered = q.isEmpty
        ? List<api.Profile>.from(_profiles)
        : _profiles.where((p) => p.name.toLowerCase().contains(q)).toList();
    int roleRank(api.Profile p) {
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
    _visibleProfiles = filtered;
  }

  @override
  void initState() {
    super.initState();
    _gang = widget.gang;
    _loadData();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    _recomputeVisibleProfiles();
    setState(() {});
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
    if (!mounted) return;
    setState(() {
      _profiles = results[0] as List<api.Profile>;
      _equipment = results[1] as List<api.Equipment>;
      _spells = results[2] as List<api.Spell>;
      _loading = false;
      _recomputeVisibleProfiles();
    });
  }

  Future<void> _editSpells(api.ListEntry entry) async {
    if (_busy) return;
    final result = await showDialog<_SpellSelection>(
      context: context,
      builder: (_) => _SpellPickerDialog(entry: entry, allSpells: _spells),
    );
    if (result == null || !mounted) return;
    setState(() => _busy = true);
    try {
      final updated = await GangService().setEntrySpells(
        entry.id,
        result.discipline,
        result.spellIds,
      );
      if (!mounted) return;
      setState(() => _gang = updated);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  int _entryCount(api.Profile p) => _gang.entries
      .where(
        (e) =>
            e.entryType ==
                api.ListEntryEntryTypeEnum.catalogColonColonCardReference &&
            p.cardReferenceIds.contains(e.entryId),
      )
      .length;

  api.ListEntry? _entryFor(api.Profile p) {
    try {
      return _gang.entries.firstWhere(
        (e) =>
            e.entryType ==
                api.ListEntryEntryTypeEnum.catalogColonColonCardReference &&
            p.cardReferenceIds.contains(e.entryId),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> _add(api.Profile p) async {
    if (_busy) return;
    final refId = p.cardReferenceId;
    if (refId == null) return; // no printed card → nothing to hire
    setState(() => _busy = true);
    try {
      final updated = await GangService().addEntry(
        _gang.id,
        refId,
        'CardReference',
      );
      if (!mounted) return;
      setState(() => _gang = updated);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _addEquipment(api.Equipment e) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final updated = await GangService().addEntry(_gang.id, e.id, 'Equipment');
      if (!mounted) return;
      setState(() => _gang = updated);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _remove(api.Profile p) async {
    final entry = _entryFor(p);
    if (entry == null || _busy) return;
    setState(() => _busy = true);
    try {
      final updated = await GangService().removeEntry(entry.id);
      if (!mounted) return;
      setState(() => _gang = updated);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _removeEntry(api.ListEntry entry) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final updated = await GangService().removeEntry(entry.id);
      if (!mounted) return;
      setState(() => _gang = updated);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _reorderEntry(int oldIndex, int newIndex) async {
    if (_busy) return;
    if (newIndex > oldIndex) newIndex--;
    if (newIndex == oldIndex) return;
    final entry = _gang.entries[oldIndex];
    final reordered = List<api.ListEntry>.from(_gang.entries)
      ..removeAt(oldIndex)
      ..insert(newIndex, entry);
    setState(() {
      _gang = _gang.rebuild((b) => b..entries.replace(reordered));
      _busy = true;
    });
    try {
      final updated = await GangService().reorderEntry(entry.id, newIndex + 1);
      if (!mounted) return;
      setState(() => _gang = updated);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final factionColor =
        AppPalette.factionColors[_gang.faction] ?? context.accentColor;
    return Scaffold(
      backgroundColor: AppPalette.background,
      body: AppBackground(
        child: Column(
          children: [
            _buildHeader(context, factionColor),
            PointsBar(
              used: _gang.totalCost,
              limit: _gang.points,
              factionColor: factionColor,
              editable: true,
            ),
            if (_gang.entries.isNotEmpty && !_gang.selectionValid)
              _buildValidityPanel(),
            const SizedBox(height: 12),
            _buildTabBar(factionColor),
            const SizedBox(height: 8),
            Expanded(child: _buildTabContent(factionColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color factionColor) {
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
              _gang.name ?? '',
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
          FactionBadge(faction: _gang.faction, color: factionColor, size: 38),
        ],
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
      spans.add(
        TextSpan(
          text: m.group(0),
          style: base.copyWith(fontWeight: FontWeight.w700),
        ),
      );
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
            final base = TextStyle(
              fontSize: 12,
              color: Colors.white,
              height: 1.4,
            );
            return Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
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
      child: GlassPanel(
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
    );
  }

  Widget _buildTabContent(Color factionColor) {
    if (_loading) {
      return Center(
        child: CircularProgressIndicator(color: context.accentColor),
      );
    }
    // Build only the active tab rather than eagerly laying out both (F-P3-6). The list/hire tabs
    // hold no scroll/selection state worth preserving across a switch.
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
            Icon(
              Icons.group_outlined,
              size: 48,
              color: context.subtleTextColor.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 12),
            Text(
              'No models hired yet',
              style: GoogleFonts.cinzel(
                fontSize: 15,
                color: context.subtleTextColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Go to Hire to add models',
              style: TextStyle(
                fontSize: 12,
                color: context.subtleTextColor.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }
    final hiredProfiles = entries
        .where(
          (e) =>
              e.entryType ==
              api.ListEntryEntryTypeEnum.catalogColonColonCardReference,
        )
        .map(
          (e) => _profiles
              .where((p) => p.cardReferenceIds.contains(e.entryId))
              .firstOrNull,
        )
        .whereType<api.Profile>()
        .toList();
    return ReorderableListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
      onReorder: _reorderEntry,
      proxyDecorator: (child, _, __) => child,
      buildDefaultDragHandles: false,
      itemCount: entries.length,
      itemBuilder: (_, i) {
        final entry = entries[i];
        final profileIdx =
            entry.entryType ==
                api.ListEntryEntryTypeEnum.catalogColonColonCardReference
            ? _profiles.indexWhere(
                (p) => p.cardReferenceIds.contains(entry.entryId),
              )
            : -1;
        final profile = profileIdx != -1 ? _profiles[profileIdx] : null;
        final equipmentItem =
            entry.entryType ==
                api.ListEntryEntryTypeEnum.catalogColonColonEquipment
            ? _equipment.where((e) => e.id == entry.entryId).firstOrNull
            : null;
        final entryColor =
            entry.entryType ==
                api.ListEntryEntryTypeEnum.catalogColonColonEquipment
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
          final hiredIndex = hiredProfiles.indexWhere(
            (p) => p.cardReferenceId == profile.cardReferenceId,
          );
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
          onTap = () => showEquipmentDetailDialog(context, equipmentItem);
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
    final profiles = _visibleProfiles;

    final factionProfiles = _gang.faction == 'gifted'
        ? profiles
        : profiles.where((p) => p.faction == _gang.faction).toList();
    final giftedProfiles = _gang.faction == 'gifted'
        ? <api.Profile>[]
        : profiles.where((p) => p.faction == 'gifted').toList();

    final hasLeader = _profiles.any(
      (p) => p.keywords.contains('Leader') && _entryCount(p) > 0,
    );

    Widget buildTile(api.Profile p) {
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
                  child: Text(
                    'No profiles for this faction.',
                    style: TextStyle(color: context.subtleTextColor),
                  ),
                )
              : profiles.isEmpty
              ? Center(
                  child: Text(
                    'No profiles match your search.',
                    style: TextStyle(color: context.subtleTextColor),
                  ),
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
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
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
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (_, i) {
                            final e = _equipment[i];
                            final count = _gang.entries
                                .where(
                                  (en) =>
                                      en.entryType ==
                                          api
                                              .ListEntryEntryTypeEnum
                                              .catalogColonColonEquipment &&
                                      en.entryId == e.id,
                                )
                                .length;
                            final canAdd = count == 0;
                            return _HireEquipmentTile(
                              equipment: e,
                              count: count,
                              canAdd: canAdd,
                              busy: _busy,
                              onAdd: () => _addEquipment(e),
                              onTap: () =>
                                  showEquipmentDetailDialog(context, e),
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
          Expanded(
            child: Divider(
              color: context.subtleTextColor.withValues(alpha: 0.3),
              thickness: 0.5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 11,
                color: context.subtleTextColor.withValues(alpha: 0.7),
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: context.subtleTextColor.withValues(alpha: 0.3),
              thickness: 0.5,
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildHireControls() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        children: [
          GlassPanel(
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
                prefixIcon: Icon(
                  Icons.search,
                  color: context.accentColor,
                  size: 20,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: context.subtleTextColor.withValues(alpha: 0.6),
                          size: 18,
                        ),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              for (final option in const [
                (label: 'Role', value: _HireSort.role),
                (label: 'Name', value: _HireSort.name),
                (label: 'Cost', value: _HireSort.cost),
              ]) ...[
                if (option.value != _HireSort.role) const SizedBox(width: 6),
                SortChip(
                  label: option.label,
                  selected: _hireSort == option.value,
                  ascending: _hireSortAsc,
                  onTap: () => setState(() {
                    final (field, asc) = applySortTap(
                      option.value,
                      _hireSort,
                      _hireSortAsc,
                    );
                    _hireSort = field;
                    _hireSortAsc = asc;
                    _recomputeVisibleProfiles();
                  }),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
