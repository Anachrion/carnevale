import '../app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import '../main.dart';
import '../services/gang_service.dart';
import '../widgets/app_background.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_input.dart';
import '../widgets/bottom_sheet_surface.dart';
import '../widgets/glass_panel.dart';
import '../widgets/screen_header.dart';
import '../widgets/status_views.dart';
import 'account_screen.dart';
import 'gang_builder_screen.dart';

// Faction display order for the create-gang picker (distinct from AppPalette.factionColors' order).
const _kFactions = [
  'guild',
  'doctors',
  'vatican',
  'patricians',
  'strigoi',
  'gifted',
  'rashaar',
];

class GangsScreen extends StatefulWidget {
  const GangsScreen({super.key});

  @override
  State<GangsScreen> createState() => _GangsScreenState();
}

class _GangsScreenState extends State<GangsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _service = GangService();
  List<api.ModelList> _gangs = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    authService.addListener(_onAuthChanged);
    if (authService.isLoggedIn) {
      _load();
    } else {
      _loading = false;
    }
  }

  @override
  void dispose() {
    authService.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    if (authService.isLoggedIn) {
      _load();
    } else if (mounted) {
      setState(() {
        _gangs = [];
        _error = null;
        _loading = false;
      });
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final gangs = await _service.loadAll();
      if (!mounted) return;
      setState(() {
        _gangs = gangs;
        _loading = false;
      });
    } catch (e, st) {
      debugPrint('GangsScreen error: $e\n$st');
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _deleteGang(int id) async {
    await _service.delete(id);
    await _load();
  }

  void _showCreateDialog() async {
    final gang = await showModalBottomSheet<api.ModelList>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CreateGangSheet(
        onCreate: (name, faction, points) =>
            _service.create(name, faction, points),
      ),
    );
    if (gang != null && mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => GangBuilderScreen(gang: gang)),
      );
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppPalette.background,
      drawer: const AppDrawer(current: AppDrawerRoute.gangs),
      floatingActionButton: authService.isLoggedIn
          ? FloatingActionButton(
              onPressed: _showCreateDialog,
              backgroundColor: AppPalette.gold,
              foregroundColor: Colors.white,
              mini: true,
              child: const Icon(Icons.add),
            )
          : null,
      body: AppBackground(
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 8),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return ScreenHeader(
      title: 'Gangs',
      onMenu: () => _scaffoldKey.currentState?.openDrawer(),
      trailing: authService.isLoggedIn && !_loading && _error == null
          ? Text(
              '${_gangs.length} gang${_gangs.length == 1 ? '' : 's'}',
              style: TextStyle(fontSize: 12, color: context.subtleTextColor),
            )
          : null,
    );
  }

  Widget _buildLoggedOut() {
    return LoggedOutView(
      message: 'Log in to build and manage your gangs',
      onLogin: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AccountScreen()),
      ),
    );
  }

  Widget _buildBody() {
    if (!authService.isLoggedIn) {
      return _buildLoggedOut();
    }
    if (_loading) {
      return const LoadingView();
    }
    if (_error != null) {
      return ErrorRetryView(onRetry: _load);
    }
    if (_gangs.isEmpty) return _buildEmpty();
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      itemCount: _gangs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _GangTile(
        gang: _gangs[i],
        onDelete: () => _deleteGang(_gangs[i].id),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => GangBuilderScreen(gang: _gangs[i]),
            ),
          );
          await _load();
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.flag_outlined,
            size: 56,
            color: context.subtleTextColor.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'No gangs yet',
            style: GoogleFonts.cinzel(
              fontSize: 16,
              color: context.subtleTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to create your first gang',
            style: TextStyle(
              fontSize: 13,
              color: context.subtleTextColor.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _GangTile extends StatelessWidget {
  const _GangTile({
    required this.gang,
    required this.onDelete,
    required this.onTap,
  });
  final api.ModelList gang;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final factionColor =
        AppPalette.factionColors[gang.faction] ?? AppPalette.gold;
    final iconPath = AppPalette.factionIcons[gang.faction];

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GlassPanel(
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          onLongPress: () => _confirmDelete(context),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: factionColor,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: iconPath != null
                      ? Image.asset(
                          iconPath,
                          fit: BoxFit.contain,
                          color: Colors.white,
                          colorBlendMode: BlendMode.srcIn,
                        )
                      : const Icon(Icons.flag, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        gang.name ?? '',
                        style: GoogleFonts.cinzel(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: context.textColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _factionLabel(gang.faction),
                        style: TextStyle(
                          fontSize: 12,
                          color: factionColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${gang.totalCost}',
                      style: GoogleFonts.cinzel(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppPalette.gold,
                      ),
                    ),
                    Text(
                      '/ ${gang.points} duc.',
                      style: TextStyle(
                        fontSize: 10,
                        color: context.subtleTextColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  color: isDark ? AppPalette.gold : AppPalette.red,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          'Delete Gang',
          style: GoogleFonts.cinzel(color: context.textColor),
        ),
        content: Text('Delete "${gang.name ?? ''}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _factionLabel(String f) => f[0].toUpperCase() + f.substring(1);
}

class _CreateGangSheet extends StatefulWidget {
  const _CreateGangSheet({required this.onCreate});
  final Future<api.ModelList> Function(String name, String faction, int points)
  onCreate;

  @override
  State<_CreateGangSheet> createState() => _CreateGangSheetState();
}

class _CreateGangSheetState extends State<_CreateGangSheet> {
  final _nameController = TextEditingController();
  final _pointsController = TextEditingController(text: '100');
  String _selectedFaction = _kFactions.first;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final points = int.tryParse(_pointsController.text.trim()) ?? 100;
    setState(() => _saving = true);
    try {
      final gang = await widget.onCreate(name, _selectedFaction, points);
      if (mounted) Navigator.of(context).pop(gang);
    } catch (_) {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetSurface(
      scrollable: true,
      title: 'New Gang',
      children: [
        TextField(
          controller: _nameController,
          autofocus: true,
          style: GoogleFonts.cinzel(color: context.textColor, fontSize: 15),
          decoration: goldInputDecoration(context, label: 'Gang name'),
          onSubmitted: (_) => _submit(),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _pointsController,
          keyboardType: TextInputType.number,
          style: GoogleFonts.cinzel(color: context.textColor, fontSize: 15),
          decoration: goldInputDecoration(context, label: 'Point limit'),
        ),
        const SizedBox(height: 24),
        Text(
          'Faction',
          style: TextStyle(
            fontSize: 12,
            color: context.subtleTextColor,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 52,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _kFactions.map((f) {
              final selected = f == _selectedFaction;
              final color = AppPalette.factionColors[f] ?? AppPalette.gold;
              final iconPath = AppPalette.factionIcons[f]!;
              return GestureDetector(
                onTap: () => setState(() => _selectedFaction = f),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? color : color.withValues(alpha: 0.35),
                    border: selected
                        ? Border.all(color: Colors.white, width: 2.5)
                        : null,
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: color.withValues(alpha: 0.5),
                              blurRadius: 8,
                            ),
                          ]
                        : null,
                  ),
                  padding: const EdgeInsets.all(9),
                  child: Image.asset(
                    iconPath,
                    fit: BoxFit.contain,
                    color: Colors.white,
                    colorBlendMode: BlendMode.srcIn,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _saving ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPalette.gold,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Create Gang',
                    style: GoogleFonts.cinzel(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
