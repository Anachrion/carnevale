import '../app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import '../main.dart';
import '../services/gang_service.dart';
import '../widgets/app_background.dart';
import '../widgets/app_drawer.dart';
import '../widgets/create_gang_sheet.dart';
import '../widgets/gang_tile.dart';
import '../widgets/screen_header.dart';
import '../widgets/status_views.dart';
import 'account_screen.dart';
import 'gang_builder_screen.dart';

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
  // Id of the gang whose roster is expanded inline; only one is open at a time.
  int? _expandedId;

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
      builder: (_) => CreateGangSheet(
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      itemCount: _gangs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final gang = _gangs[i];
        final expanded = _expandedId == gang.id;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GangTile(
              name: gang.name,
              faction: gang.faction,
              totalCost: gang.totalCost,
              points: gang.points,
              onLongPress: () => _confirmDelete(gang),
              onTap: () => setState(
                () => _expandedId = expanded ? null : gang.id,
              ),
              trailing: AnimatedRotation(
                turns: expanded ? 0.25 : 0,
                duration: const Duration(milliseconds: 400),
                child: Icon(
                  Icons.chevron_right,
                  color: isDark ? AppPalette.gold : AppPalette.red,
                  size: 20,
                ),
              ),
              footer: expanded ? _tileActions(gang) : null,
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              alignment: Alignment.topCenter,
              child: expanded
                  ? _GangRosterPreview(gang: gang)
                  : const SizedBox(width: double.infinity),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editGang(api.ModelList gang) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GangBuilderScreen(gang: gang)),
    );
    await _load();
  }

  /// Edit/Delete row revealed inside the tile once it's expanded. Each button
  /// has its own tap handler, so it acts without also toggling the expansion.
  Widget _tileActions(api.ModelList gang) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: () => _editGang(gang),
            icon: const Icon(Icons.edit_outlined, size: 16),
            style: TextButton.styleFrom(
              foregroundColor: AppPalette.gold,
              side: const BorderSide(color: AppPalette.gold),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            label: Text(
              'Edit',
              style: GoogleFonts.cinzel(
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () => _confirmDelete(gang),
            icon: const Icon(Icons.delete_outline, size: 16),
            style: TextButton.styleFrom(
              foregroundColor: AppPalette.red,
              side: const BorderSide(color: AppPalette.red),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            label: Text(
              'Delete',
              style: GoogleFonts.cinzel(
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(api.ModelList gang) {
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
              _deleteGang(gang.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
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

/// The roster shown when a gang row is expanded on the Gangs tab: each hired
/// entry with its ducat cost. (Editing is triggered from the tile itself.)
class _GangRosterPreview extends StatelessWidget {
  const _GangRosterPreview({required this.gang});

  final api.ModelList gang;

  @override
  Widget build(BuildContext context) {
    final entries = gang.entries.toList()
      ..sort((a, b) => a.position.compareTo(b.position));
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      decoration: BoxDecoration(
        gradient: context.panelGradient,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.panelBorderColor, width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (entries.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                'No models hired yet.',
                style: TextStyle(
                  fontSize: 13,
                  color: context.subtleTextColor,
                ),
              ),
            )
          else
            for (final entry in entries)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.name,
                        style: TextStyle(fontSize: 13, color: context.textColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${entry.cost}',
                      style: GoogleFonts.cinzel(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: context.accentColor,
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
