import 'dart:ui';
import '../app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/gang.dart';
import '../services/gang_service.dart';
import 'gang_builder_screen.dart';

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

const _kFactions = ['guild', 'doctors', 'vatican', 'patricians', 'strigoi', 'gifted', 'rashaar'];

class GangsScreen extends StatefulWidget {
  const GangsScreen({super.key});

  @override
  State<GangsScreen> createState() => _GangsScreenState();
}

class _GangsScreenState extends State<GangsScreen> {
  final _service = GangService();
  List<Gang> _gangs = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final gangs = await _service.loadAll();
      setState(() { _gangs = gangs; _loading = false; });
    } catch (e, st) {
      debugPrint('GangsScreen error: $e\n$st');
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  Future<void> _deleteGang(int id) async {
    await _service.delete(id);
    await _load();
  }

  void _showCreateDialog() async {
    final gang = await showModalBottomSheet<Gang>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CreateGangSheet(
        onCreate: (name, faction, points) => _service.create(name, faction, points),
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
      backgroundColor: _kBackground,
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateDialog,
        backgroundColor: _kGold,
        foregroundColor: Colors.white,
        mini: true,
        child: const Icon(Icons.add),
      ),
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
                    Expanded(child: _buildBody()),
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
          Text(
            'Gangs',
            style: GoogleFonts.cinzel(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: context.textColor,
              letterSpacing: 3,
            ),
          ),
          const Spacer(),
          if (!_loading && _error == null)
            Text(
              '${_gangs.length} gang${_gangs.length == 1 ? '' : 's'}',
              style: TextStyle(fontSize: 12, color: context.subtleTextColor),
            ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator(color: _kGold));
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off, size: 40, color: context.subtleTextColor),
            const SizedBox(height: 12),
            Text('Could not reach server', style: TextStyle(color: context.subtleTextColor)),
            const SizedBox(height: 8),
            TextButton(onPressed: _load, child: const Text('Retry')),
          ],
        ),
      );
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
            MaterialPageRoute(builder: (_) => GangBuilderScreen(gang: _gangs[i])),
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
          Icon(Icons.flag_outlined, size: 56, color: context.subtleTextColor.withOpacity(0.4)),
          const SizedBox(height: 16),
          Text(
            'No gangs yet',
            style: GoogleFonts.cinzel(fontSize: 16, color: context.subtleTextColor),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to create your first gang',
            style: TextStyle(fontSize: 13, color: context.subtleTextColor.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }
}

class _GangTile extends StatelessWidget {
  const _GangTile({required this.gang, required this.onDelete, required this.onTap});
  final Gang gang;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final factionColor = _kFactionColors[gang.faction] ?? _kGold;
    final iconPath = _kFactionIcons[gang.faction];

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: context.cardBgColor.withOpacity(0.7),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 0.5),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
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
                            gang.name,
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
                            color: _kGold,
                          ),
                        ),
                        Text(
                          '/ ${gang.points} duc.',
                          style: TextStyle(fontSize: 10, color: context.subtleTextColor),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right, color: _kGold, size: 20),
                  ],
                ),
              ),
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
        title: Text('Delete Gang', style: GoogleFonts.cinzel(color: context.textColor)),
        content: Text('Delete "${gang.name}"?'),
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
  final Future<Gang> Function(String name, String faction, int points) onCreate;

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
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: context.cardBgColor.withOpacity(0.92),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border.all(color: Colors.white.withOpacity(0.4), width: 0.5),
            ),
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(
                        color: context.subtleTextColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'New Gang',
                    style: GoogleFonts.cinzel(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: context.textColor,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nameController,
                    autofocus: true,
                    style: GoogleFonts.cinzel(color: context.textColor, fontSize: 15),
                    decoration: InputDecoration(
                      labelText: 'Gang name',
                      labelStyle: TextStyle(color: context.subtleTextColor, fontSize: 13),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: _kGold.withOpacity(0.5)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: _kGold, width: 1.5),
                      ),
                    ),
                    onSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _pointsController,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.cinzel(color: context.textColor, fontSize: 15),
                    decoration: InputDecoration(
                      labelText: 'Point limit',
                      labelStyle: TextStyle(color: context.subtleTextColor, fontSize: 13),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: _kGold.withOpacity(0.5)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: _kGold, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Faction',
                    style: TextStyle(fontSize: 12, color: context.subtleTextColor, letterSpacing: 1),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 52,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _kFactions.map((f) {
                        final selected = f == _selectedFaction;
                        final color = _kFactionColors[f] ?? _kGold;
                        final iconPath = _kFactionIcons[f]!;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedFaction = f),
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: selected ? color : color.withOpacity(0.35),
                              border: selected
                                  ? Border.all(color: Colors.white, width: 2.5)
                                  : null,
                              boxShadow: selected
                                  ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 8)]
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
                        backgroundColor: _kGold,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _saving
                          ? const SizedBox(
                              width: 20, height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : Text(
                              'Create Gang',
                              style: GoogleFonts.cinzel(fontWeight: FontWeight.w700, fontSize: 15),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
