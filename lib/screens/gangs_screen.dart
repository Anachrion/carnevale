// Carnevale Companion
// Copyright (C) 2026 Anachrion and contributors
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU Affero General Public License as published by the Free
// Software Foundation, either version 3 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
// details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

import 'dart:async';

import '../app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../services/gang_service.dart';
import '../widgets/app_background.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_toast.dart';
import '../widgets/gang_text_dialogs.dart';
import '../widgets/create_gang_sheet.dart';
import '../widgets/gang_tile.dart';
import '../widgets/guarded_action.dart';
import '../widgets/screen_header.dart';
import '../widgets/status_views.dart';
import 'account_screen.dart';
import 'gang_builder_screen.dart';
import 'qr_scanner_screen.dart';

class GangsScreen extends StatefulWidget {
  const GangsScreen({super.key, this.initialImportText});

  /// Opens the import sheet pre-filled, for a gang that arrived by QR (CARNEVALEB-74).
  final String? initialImportText;

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
    if (!authService.isLoggedIn) {
      _loading = false;
      return;
    }
    // Show the last-known gangs instantly if we have them (navigating away and back shouldn't blank
    // to a spinner), then refresh in the background. Only the marginal cross-device edit case is
    // briefly stale. With no cache yet (first visit this session), fall back to a blocking load.
    final cached = _service.cachedGangs;
    if (cached != null) {
      _gangs = cached;
      _loading = false;
      _refresh();
    } else {
      _load();
    }
    final scanned = widget.initialImportText;
    if (scanned != null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _showImportSheet(initialText: scanned),
      );
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

  /// Refreshes the list in the background while the cached gangs stay on screen — no spinner, and a
  /// failure is silent since we already have something to show.
  Future<void> _refresh() async {
    try {
      final gangs = await _service.loadAll();
      if (!mounted) return;
      setState(() {
        _gangs = gangs;
        _error = null;
      });
    } catch (e) {
      debugPrint('GangsScreen background refresh failed: $e');
    }
  }

  Future<void> _deleteGang(int id) async {
    // Was fire-and-forget with no error handling: an offline delete failed silently, leaving the
    // gang on screen with no explanation (A-9). Guard it, and only reload when it actually deleted.
    final ok = await guard(context, () => _service.delete(id));
    if (ok && mounted) {
      setState(() => _gangs.removeWhere((g) => g.id == id));
      _service.cacheGangs(_gangs);
    }
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
      final updated = await Navigator.push<api.ModelList>(
        context,
        MaterialPageRoute(builder: (_) => GangBuilderScreen(gang: gang)),
      );
      if (mounted) _upsertGang(updated ?? gang);
    }
  }

  /// Builds a gang from pasted text (CARNEVALEB-74). Unlike create, this does not push into the
  /// builder: an imported gang already has its models, so it belongs in the list straight away —
  /// and the sheet has already shown anything the server could not resolve.
  void _showImportSheet({String? initialText}) async {
    final gang = await showGangImportSheet(context, initialText: initialText);
    if (gang == null || !mounted) return;
    _upsertGang(gang);
    showAppToast(
      context,
      AppLocalizations.of(context).toastGangImported(gang.name ?? ''),
    );
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
              backgroundColor: context.accentColor,
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
      title: AppLocalizations.of(context).navGangs,
      onMenu: () => _scaffoldKey.currentState?.openDrawer(),
      // Count plus the way in for a gang somebody sent you. Import sits here rather than beside the
      // create button: creating is the primary action and keeps the floating button to itself.
      trailing: authService.isLoggedIn && !_loading && _error == null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppLocalizations.of(context).gangCount(_gangs.length),
                  style: TextStyle(fontSize: 12, color: context.subtleTextColor),
                ),
                if (scanningSupported)
                  IconButton(
                    icon: Icon(
                      Icons.qr_code_scanner,
                      color: context.accentColor,
                      size: 20,
                    ),
                    tooltip: AppLocalizations.of(context).navScan,
                    onPressed: () => scanAndOpen(context),
                  ),
                IconButton(
                  icon: Icon(
                    Icons.file_download,
                    color: context.accentColor,
                    size: 20,
                  ),
                  tooltip: AppLocalizations.of(context).gangImportTitle,
                  onPressed: _showImportSheet,
                ),
              ],
            )
          : null,
    );
  }

  Widget _buildLoggedOut() {
    return LoggedOutView(
      message: AppLocalizations.of(context).gangsLoginPrompt,
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
      separatorBuilder: (_, _) => const SizedBox(height: 10),
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
              onTap: () =>
                  setState(() => _expandedId = expanded ? null : gang.id),
              trailing: AnimatedRotation(
                turns: expanded ? 0.25 : 0,
                duration: const Duration(milliseconds: 400),
                child: Icon(
                  Icons.chevron_right,
                  color: context.accentColor,
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
    final updated = await Navigator.push<api.ModelList>(
      context,
      MaterialPageRoute(builder: (_) => GangBuilderScreen(gang: gang)),
    );
    if (updated != null && mounted) _upsertGang(updated);
  }

  /// Patches the index from the up-to-date gang the builder hands back on the way out — replacing
  /// that one row in place (or appending a new gang). The other gangs can't change while you're
  /// inside one, and the builder already knows the edited gang's state (cost included), so there's
  /// nothing to refetch and no spinner on return.
  void _upsertGang(api.ModelList gang) {
    setState(() {
      final i = _gangs.indexWhere((g) => g.id == gang.id);
      if (i >= 0) {
        _gangs[i] = gang;
      } else {
        _gangs.add(gang);
      }
    });
    _service.cacheGangs(_gangs);
  }

  /// Edit/Delete row revealed inside the tile once it's expanded. Each button
  /// has its own tap handler, so it acts without also toggling the expansion.
  Widget _tileActions(api.ModelList gang) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: () => _editGang(gang),
            icon: const Icon(Icons.edit_outlined, size: 16),
            style: TextButton.styleFrom(
              foregroundColor: context.accentColor,
              side: BorderSide(color: context.accentColor),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            label: Text(
              l10n.actionEdit,
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
              foregroundColor: context.dangerColor,
              side: BorderSide(color: context.dangerColor),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            label: Text(
              l10n.actionDelete,
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
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          l10n.gangDeleteTitle,
          style: GoogleFonts.cinzel(color: context.textColor),
        ),
        content: Text(l10n.deleteGangConfirm(gang.name ?? '')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.actionCancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              unawaited(_deleteGang(gang.id));
            },
            child: Text(l10n.actionDelete, style: TextStyle(color: context.dangerColor)),
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
            AppLocalizations.of(context).gangsEmptyTitle,
            style: GoogleFonts.cinzel(
              fontSize: 16,
              color: context.subtleTextColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).gangsEmptySubtitle,
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
    // Label each model by its profile name (dropping the card-reference letter) and number the
    // copies in list order when a model is hired more than once. Equipment (no profileName) keeps
    // its own name and isn't numbered.
    final counts = <String, int>{};
    for (final e in entries) {
      final key = e.profileName;
      if (key != null) counts[key] = (counts[key] ?? 0) + 1;
    }
    final seen = <String, int>{};
    final displayName = <int, String>{};
    for (final e in entries) {
      final base = e.profileName;
      if (base == null) {
        displayName[e.id] = e.name;
      } else if ((counts[base] ?? 0) > 1) {
        final n = (seen[base] ?? 0) + 1;
        seen[base] = n;
        displayName[e.id] = '$base $n';
      } else {
        displayName[e.id] = base;
      }
    }
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
                AppLocalizations.of(context).gangsRosterNoModels,
                style: TextStyle(fontSize: 13, color: context.subtleTextColor),
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
                        displayName[entry.id] ?? entry.name,
                        style: TextStyle(
                          fontSize: 13,
                          color: context.textColor,
                        ),
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
