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

import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../app_colors.dart';
import '../l10n/app_localizations.dart';
import '../services/api_exception.dart';
import '../services/gang_service.dart';
import 'app_toast.dart';
import 'bottom_sheet_surface.dart';
import 'themed_dialog_card.dart';

/// The two ends of the plain-text gang exchange (CARNEVALEB-74): showing a gang as text to copy or
/// send, and building a new one from text somebody sent you.
///
/// Both render the text in a monospace block. That is not styling for its own sake — the format
/// carries meaning in its indentation (a model's Disciplines and the spells under them), and in a
/// proportional face that structure stops being legible.

/// Shows [gangId] as text, with actions to copy it or hand it to the OS share sheet.
Future<void> showGangExportDialog(BuildContext context, int gangId) {
  return showDialog<void>(
    context: context,
    builder: (_) => _GangExportDialog(gangId: gangId),
  );
}

/// Collects pasted text and imports it. Resolves to the gang that was created, or null if the user
/// backed out — the caller adds it to its list rather than refetching.
Future<api.ModelList?> showGangImportSheet(BuildContext context) {
  return showModalBottomSheet<api.ModelList>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _GangImportSheet(),
  );
}

// ── Export ───────────────────────────────────────────────────────────────────

class _GangExportDialog extends StatefulWidget {
  const _GangExportDialog({required this.gangId});

  final int gangId;

  @override
  State<_GangExportDialog> createState() => _GangExportDialogState();
}

class _GangExportDialogState extends State<_GangExportDialog> {
  late final Future<String> _text = GangService().exportText(widget.gangId);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ThemedDialogCard(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: FutureBuilder<String>(
        future: _text,
        builder: (context, snapshot) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.gangExportTitle,
                style: GoogleFonts.cinzel(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: context.textColor,
                ),
              ),
              const SizedBox(height: 14),
              if (snapshot.hasError)
                Text(
                  snapshot.error is ApiException
                      ? (snapshot.error as ApiException).message
                      : l10n.gangExportFailed,
                  style: TextStyle(color: context.subtleTextColor, fontSize: 13),
                )
              else if (!snapshot.hasData)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 28),
                  child: Center(
                    child: CircularProgressIndicator(color: context.accentColor),
                  ),
                )
              else ...[
                _TextPlate(text: snapshot.data!),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _DialogButton(
                        icon: Icons.content_copy,
                        label: l10n.gangExportCopy,
                        onTap: () => _copy(snapshot.data!),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _DialogButton(
                        icon: Icons.ios_share,
                        label: l10n.gangExportShare,
                        filled: true,
                        onTap: () => _share(snapshot.data!),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Future<void> _copy(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    showAppToast(context, AppLocalizations.of(context).toastGangCopied);
  }

  Future<void> _share(String text) async {
    try {
      await SharePlus.instance.share(ShareParams(text: text));
    } catch (_) {
      // Nowhere to share to (a device with no messaging app, a desktop target). Fall back to the
      // clipboard rather than reporting a dead end — the same thing the Copy button beside it does.
      await Clipboard.setData(ClipboardData(text: text));
      if (mounted) {
        showAppToast(context, AppLocalizations.of(context).toastGangCopied);
      }
    }
  }
}

// ── Import ───────────────────────────────────────────────────────────────────

class _GangImportSheet extends StatefulWidget {
  const _GangImportSheet();

  @override
  State<_GangImportSheet> createState() => _GangImportSheetState();
}

class _GangImportSheetState extends State<_GangImportSheet> {
  final _controller = TextEditingController();
  bool _busy = false;
  String? _error;
  // Filled once the server has answered: what it could not resolve. Import succeeds partially by
  // design, so these are shown rather than swallowed — otherwise the gang arrives quietly short.
  List<String> _warnings = const [];
  api.ModelList? _imported;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BottomSheetSurface(
      title: l10n.gangImportTitle,
      scrollable: true,
      children: [
        TextField(
          controller: _controller,
          maxLines: 8,
          minLines: 5,
          style: GoogleFonts.robotoMono(fontSize: 11.5, color: context.textColor),
          decoration: InputDecoration(
            hintText: l10n.gangImportHint,
            hintStyle: TextStyle(
              color: context.subtleTextColor.withValues(alpha: 0.6),
              fontSize: 13,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: context.accentColor.withValues(alpha: 0.5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: context.accentColor.withValues(alpha: 0.5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: context.accentColor, width: 1.4),
            ),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 10),
          Text(
            _error!,
            style: TextStyle(color: AppPalette.brightRed, fontSize: 12.5),
          ),
        ],
        if (_warnings.isNotEmpty) ...[
          const SizedBox(height: 14),
          _WarningList(warnings: _warnings),
        ],
        const SizedBox(height: 16),
        // The gang already exists by now; all that is left is reading the warnings and leaving.
        // Keeping "Import" enabled here would let a second tap build a duplicate gang from the same
        // text — the sheet only stayed open because there was something to read.
        if (_imported != null)
          _DialogButton(
            icon: Icons.check,
            label: l10n.actionDone,
            filled: true,
            onTap: () => Navigator.pop(context, _imported),
          )
        else
          Row(
            children: [
              Expanded(
                child: _DialogButton(
                  icon: Icons.content_paste,
                  label: l10n.gangImportPaste,
                  onTap: _busy ? null : _paste,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _DialogButton(
                  icon: Icons.file_download,
                  label: l10n.gangImportAction,
                  filled: true,
                  busy: _busy,
                  onTap: _busy ? null : _import,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Future<void> _paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text;
    if (text == null || text.trim().isEmpty) return;
    setState(() {
      _controller.text = text;
      _error = null;
    });
  }

  Future<void> _import() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() => _error = AppLocalizations.of(context).gangImportEmpty);
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
      _warnings = const [];
    });
    try {
      final result = await GangService().importText(text);
      if (!mounted) return;
      // Warnings are worth a beat on screen before the sheet closes, so a partial import doesn't
      // vanish behind a toast. With none, there is nothing to read and it closes straight away.
      if (result.warnings.isEmpty) {
        Navigator.pop(context, result.gang);
        return;
      }
      setState(() {
        _busy = false;
        _warnings = result.warnings;
        _imported = result.gang;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = e is ApiException
            ? e.message
            : AppLocalizations.of(context).gangImportFailed;
      });
    }
  }
}

/// The skipped-line report. Deliberately not a toast: a toast for four warnings is unreadable, and
/// this is the one moment the user can tell whether the gang they just imported is the whole gang.
class _WarningList extends StatelessWidget {
  const _WarningList({required this.warnings});

  final List<String> warnings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 11),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: AppPalette.mutedGold, width: 2.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.gangImportSkipped(warnings.length),
            style: GoogleFonts.cinzel(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: AppPalette.mutedGold,
            ),
          ),
          const SizedBox(height: 5),
          ...warnings.map(
            (w) => Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                w,
                style: TextStyle(fontSize: 11.5, color: context.subtleTextColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The exported text on a tinted plate. Monospace and horizontally scrollable rather than wrapped:
/// the format's indentation is what makes a model's spell selection readable, and re-wrapping long
/// lines would break exactly the alignment that carries the meaning.
class _TextPlate extends StatelessWidget {
  const _TextPlate({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 260),
      decoration: BoxDecoration(
        color: context.accentColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.accentColor.withValues(alpha: 0.25)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SelectableText(
            text,
            style: GoogleFonts.robotoMono(
              fontSize: 11,
              height: 1.55,
              color: context.textColor.withValues(alpha: 0.9),
            ),
          ),
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.filled = false,
    this.busy = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool filled;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final child = busy
        ? const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: filled ? Colors.white : context.accentColor),
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cinzel(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: filled ? Colors.white : context.textColor,
                  ),
                ),
              ),
            ],
          );

    return filled
        ? ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: context.accentColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: child,
          )
        : OutlinedButton(
            onPressed: onTap,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: context.accentColor.withValues(alpha: 0.55)),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: child,
          );
  }
}
