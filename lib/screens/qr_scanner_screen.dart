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

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../app_colors.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';
import '../models/scan_target.dart';

/// Whether to offer scanning at all.
///
/// Phone-only by intent: scanning means pointing a camera at a table, and the web build runs on
/// machines where that gesture makes no sense. Every entry point checks this rather than hiding the
/// button in three places and forgetting the fourth.
final scanningSupported = !kIsWeb;

/// Opens the scanner and acts on whatever it recognised. Null result = the user backed out.
Future<void> scanAndOpen(BuildContext context) async {
  final target = await Navigator.of(context).push<ScanTarget>(
    MaterialPageRoute(builder: (_) => const QrScannerScreen()),
  );
  if (target != null) openScanTarget(target);
}

/// Reads a Carnevale QR code (CARNEVALEB-74): a game invitation, a shared game setup, or a gang.
///
/// Pops with the [ScanTarget] it recognised, leaving the caller to decide where that goes — the
/// scanner's job ends at "this is what the code said". Anything else is refused here rather than
/// carried further: see [targetForScan] for what is accepted and why the list is short.
class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final _controller = MobileScannerController(
    // One format, so a stray barcode on a model's box never competes with the code being aimed at.
    formats: const [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  /// Latched on the first code we accept. Detection is continuous — the camera re-reads the same
  /// code every frame it stays in view — so without this the screen pops (and the caller navigates)
  /// as many times as the code was seen.
  bool _handled = false;

  /// The last payload we refused, to explain it once rather than flickering the message on every
  /// frame the same foreign code is held up to the lens.
  String? _rejected;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    // A frame can carry several codes; take the first that means something to us rather than
    // refusing the lot because a poster happened to share the shot.
    for (final barcode in capture.barcodes) {
      final raw = barcode.rawValue;
      if (raw == null || raw.isEmpty) continue;
      final target = targetForScan(raw);
      if (target != null) {
        _handled = true;
        Navigator.of(context).pop(target);
        return;
      }
    }
    final first = capture.barcodes
        .map((b) => b.rawValue)
        .where((v) => v != null && v.isNotEmpty)
        .firstOrNull;
    if (first != null && first != _rejected && mounted) {
      setState(() => _rejected = first);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          l10n.scanTitle,
          style: GoogleFonts.cinzel(fontWeight: FontWeight.w700, fontSize: 17),
        ),
      ),
      // The overlays below are aiming aids, so they follow the camera's state rather than sitting
      // unconditionally on top of it: framed around an error message, a reticle invites the user to
      // aim a camera that never started, and the hint underneath tells them to keep trying.
      body: ValueListenableBuilder(
        valueListenable: _controller,
        builder: (context, state, _) {
          final failed = state.error != null;
          return Stack(
            fit: StackFit.expand,
            children: [
              MobileScanner(
                controller: _controller,
                onDetect: _onDetect,
                errorBuilder: (context, error) => _ScannerError(
                  message: switch (error.errorCode) {
                    MobileScannerErrorCode.permissionDenied =>
                      l10n.scanNoPermission,
                    MobileScannerErrorCode.unsupported => l10n.scanUnsupported,
                    _ => l10n.scanCameraFailed,
                  },
                ),
              ),
              // Guidance, not a scan window: restricting detection to it would make a code just
              // outside the frame fail silently, which reads as a broken camera.
              if (!failed)
                IgnorePointer(
                  child: Center(
                    child: Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.85),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              if (!failed)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
                    child: Text(
                      _rejected == null ? l10n.scanHint : l10n.scanUnrecognised,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: _rejected == null
                            ? Colors.white.withValues(alpha: 0.85)
                            : context.dangerColor,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ScannerError extends StatelessWidget {
  const _ScannerError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.no_photography_outlined,
              color: Colors.white.withValues(alpha: 0.7),
              size: 40,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
