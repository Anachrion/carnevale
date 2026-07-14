import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdfrx/pdfrx.dart';

import '../app_colors.dart';
import '../services/rules_service.dart';
import '../widgets/app_background.dart';
import '../widgets/status_views.dart';

/// A single rules PDF, rendered in-app.
///
/// On mobile the file is downloaded to the cache first and rendered from disk, so it opens instantly
/// on every later visit and works with no signal. The web build has no disk cache, so it hands the
/// URL to the viewer and lets the browser stream it (TT Combat's CDN allows cross-origin range
/// requests, so only the pages actually being read come down the wire).
class RulesDocumentScreen extends StatefulWidget {
  const RulesDocumentScreen({super.key, required this.doc});

  final RulesDoc doc;

  @override
  State<RulesDocumentScreen> createState() => _RulesDocumentScreenState();
}

class _RulesDocumentScreenState extends State<RulesDocumentScreen> {
  final _service = RulesService();

  /// Download progress, 0..1, or null while the total size is still unknown. A notifier rather than
  /// setState: dio fires this every few KB, and the rulebook is a large file — rebuilding only the
  /// progress bar keeps a download from rebuilding the whole screen hundreds of times.
  final _progress = ValueNotifier<double?>(null);

  String? _path;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _open();
  }

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  Future<void> _open() async {
    // Web renders straight from the URL — there is nothing to fetch up front.
    if (kIsWeb) {
      setState(() => _loading = false);
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    _progress.value = null;
    try {
      final path = await _service.localPath(
        widget.doc,
        onProgress: (received, total) {
          if (total > 0) _progress.value = received / total;
        },
      );
      if (!mounted) return;
      setState(() {
        _path = path;
        _loading = false;
      });
    } catch (e, st) {
      debugPrint('RulesDocumentScreen error: $e\n$st');
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.background,
      body: AppBackground(
        child: Column(
          children: [
            _Header(title: widget.doc.title),
            Expanded(child: _body()),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    if (_loading) return _DownloadingView(progress: _progress);
    if (_error != null) {
      return ErrorRetryView(
        onRetry: _open,
        message: 'Could not download ${widget.doc.title}',
      );
    }

    final params = PdfViewerParams(
      backgroundColor: Colors.transparent,
      margin: 8,
      loadingBannerBuilder: (_, _, _) => const LoadingView(),
      errorBannerBuilder: (_, _, _, _) => ErrorRetryView(
        onRetry: _open,
        message: 'Could not open ${widget.doc.title}',
      ),
    );

    final path = _path;
    if (path == null) {
      return PdfViewer.uri(
        Uri.parse(widget.doc.url),
        params: params,
        preferRangeAccess: true,
      );
    }
    return PdfViewer.file(path, params: params);
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: context.textColor),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.cinzel(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: context.textColor,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The spinner shown while the PDF downloads, upgraded to a real progress bar as soon as the CDN
/// tells us how big the file is — the rulebook is tens of megabytes, and a bare spinner for that
/// long reads as a hang.
class _DownloadingView extends StatelessWidget {
  const _DownloadingView({required this.progress});

  final ValueListenable<double?> progress;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double?>(
      valueListenable: progress,
      builder: (context, value, _) {
        if (value == null) return const LoadingView();
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: value,
                    minHeight: 6,
                    color: context.accentColor,
                    backgroundColor: context.panelBorderColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Downloading — ${(value * 100).round()}%',
                  style: TextStyle(color: context.subtleTextColor),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
