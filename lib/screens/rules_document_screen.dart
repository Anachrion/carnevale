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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdfrx/pdfrx.dart';

import '../app_colors.dart';
import '../l10n/app_localizations.dart';
import '../services/rules_service.dart';
import '../widgets/app_background.dart';
import '../widgets/status_views.dart';

/// A single rules PDF, rendered in-app.
///
/// On mobile the file is downloaded to the cache first and rendered from disk, so it opens instantly
/// on every later visit and works with no signal. The web build has no disk cache, so it hands the
/// URL to the viewer and lets the browser stream it (TT Combat's CDN allows cross-origin range
/// requests, so only the pages actually being read come down the wire).
///
/// The header doubles as a text-search bar: pdfrx searches the PDF's own text layer, so it works on
/// the text documents (rulebook, FAQ, …) and offline; an image-only sheet has no text to match.
class RulesDocumentScreen extends StatefulWidget {
  const RulesDocumentScreen({super.key, required this.doc});

  final RulesDoc doc;

  @override
  State<RulesDocumentScreen> createState() => _RulesDocumentScreenState();
}

class _RulesDocumentScreenState extends State<RulesDocumentScreen> {
  final _service = RulesService();
  final _controller = PdfViewerController();
  final _searchField = TextEditingController();
  final _searchFocus = FocusNode();

  /// Built only once the viewer is ready (see [_onViewerReady]) — [PdfTextSearcher]'s constructor
  /// dereferences the controller's document, which does not exist until a PDF is actually mounted.
  /// Null until then, which also gates the search affordance in the header.
  PdfTextSearcher? _searcher;

  /// Stable list so [PdfViewerParams.pagePaintCallbacks] can point at the searcher's highlight
  /// painter before the searcher exists; [_paintMatches] is a no-op until it does.
  late final List<PdfViewerPagePaintCallback> _paintCallbacks = [_paintMatches];

  /// Download progress, 0..1, or null while the total size is still unknown. A notifier rather than
  /// setState: dio fires this every few KB, and the rulebook is a large file — rebuilding only the
  /// progress bar keeps a download from rebuilding the whole screen hundreds of times.
  final _progress = ValueNotifier<double?>(null);

  bool _searching = false;
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
    _searcher?.removeListener(_onSearchUpdate);
    _searcher?.dispose();
    _searchField.dispose();
    _searchFocus.dispose();
    _progress.dispose();
    super.dispose();
  }

  void _onSearchUpdate() {
    // The searcher drives the match counter and the highlights, so rebuild as it reports progress
    // (matches trickle in page by page on a big document).
    if (mounted) setState(() {});
  }

  /// Fired by pdfrx once the document is mounted and the controller is usable. Only now is it safe
  /// to build the searcher; creating it enables the search icon.
  void _onViewerReady(PdfDocument document, PdfViewerController controller) {
    if (_searcher != null) return;
    setState(() {
      _searcher = PdfTextSearcher(controller)..addListener(_onSearchUpdate);
    });
  }

  void _paintMatches(Canvas canvas, Rect pageRect, PdfPage page) {
    _searcher?.pageTextMatchPaintCallback(canvas, pageRect, page);
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

  void _toggleSearch() {
    setState(() {
      _searching = !_searching;
      if (!_searching) {
        _searchField.clear();
        _searcher?.resetTextSearch();
      }
    });
    if (_searching) _searchFocus.requestFocus();
  }

  void _onQueryChanged(String value) {
    // startTextSearch debounces internally (~500ms) and resets on an empty pattern, so it is safe to
    // call on every keystroke.
    _searcher?.startTextSearch(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.background,
      body: AppBackground(
        child: Column(
          children: [
            _searching ? _buildSearchBar(context) : _buildTitleBar(context),
            Expanded(child: _body(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: context.textColor),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              widget.doc.title,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.cinzel(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: context.textColor,
                letterSpacing: 1.5,
              ),
            ),
          ),
          // No point offering search until the document is mounted and the searcher exists.
          if (_searcher != null)
            IconButton(
              icon: Icon(Icons.search, color: context.accentColor),
              tooltip: AppLocalizations.of(context).tooltipSearch,
              onPressed: _toggleSearch,
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final searcher = _searcher;
    final hasMatches = searcher?.hasMatches ?? false;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 8, 0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: context.textColor),
            tooltip: AppLocalizations.of(context).tooltipCloseSearch,
            onPressed: _toggleSearch,
          ),
          Expanded(
            child: TextField(
              controller: _searchField,
              focusNode: _searchFocus,
              onChanged: _onQueryChanged,
              textInputAction: TextInputAction.search,
              style: TextStyle(color: context.textColor),
              cursorColor: context.accentColor,
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: AppLocalizations.of(context).rulesSearchHint,
                hintStyle: TextStyle(color: context.subtleTextColor),
              ),
            ),
          ),
          _MatchCounter(label: _matchLabel(context), color: context.subtleTextColor),
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_up),
            color: context.accentColor,
            disabledColor: context.subtleTextColor.withValues(alpha: 0.4),
            tooltip: AppLocalizations.of(context).tooltipPreviousMatch,
            onPressed: hasMatches ? () => searcher?.goToPrevMatch() : null,
          ),
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down),
            color: context.accentColor,
            disabledColor: context.subtleTextColor.withValues(alpha: 0.4),
            tooltip: AppLocalizations.of(context).tooltipNextMatch,
            onPressed: hasMatches ? () => searcher?.goToNextMatch() : null,
          ),
        ],
      ),
    );
  }

  /// "3 / 17" once matches are in, an ellipsis while a long document is still being scanned, "None"
  /// when the query genuinely matches nothing, and blank before anything is typed.
  String _matchLabel(BuildContext context) {
    final searcher = _searcher;
    if (searcher == null || _searchField.text.isEmpty) return '';
    final total = searcher.matches.length;
    if (total == 0) return searcher.isSearching ? '…' : AppLocalizations.of(context).rulesMatchNone;
    final current = (searcher.currentIndex ?? 0) + 1;
    return '$current / $total${searcher.isSearching ? '…' : ''}';
  }

  Widget _body(BuildContext context) {
    if (_loading) return _DownloadingView(progress: _progress);
    if (_error != null) {
      return ErrorRetryView(
        onRetry: _open,
        message: AppLocalizations.of(context).rulesDownloadFailed(widget.doc.title),
      );
    }

    final params = PdfViewerParams(
      backgroundColor: Colors.transparent,
      margin: 8,
      // On-brand highlights: the muted secondary accent for every hit, the primary accent for the
      // one currently centred.
      matchTextColor: context.secondaryAccentColor.withValues(alpha: 0.35),
      activeMatchTextColor: context.accentColor.withValues(alpha: 0.5),
      pagePaintCallbacks: _paintCallbacks,
      onViewerReady: _onViewerReady,
      // A draggable thumb on the right edge to jump quickly through a long document, showing the
      // page it will land on while dragging.
      viewerOverlayBuilder: (context, size, handleLinkTap) => [
        PdfViewerScrollThumb(
          controller: _controller,
          orientation: ScrollbarOrientation.right,
          thumbSize: const Size(52, 32),
          thumbBuilder: (context, thumbSize, pageNumber, controller) => _ScrollThumb(
            page: pageNumber,
            pageCount: controller.isReady ? controller.pageCount : null,
          ),
        ),
      ],
      loadingBannerBuilder: (_, _, _) => const LoadingView(),
      errorBannerBuilder: (_, _, _, _) => ErrorRetryView(
        onRetry: _open,
        message: AppLocalizations.of(context).rulesOpenFailed(widget.doc.title),
      ),
    );

    final path = _path;
    if (path == null) {
      return PdfViewer.uri(
        Uri.parse(widget.doc.url),
        controller: _controller,
        params: params,
        preferRangeAccess: true,
      );
    }
    return PdfViewer.file(path, controller: _controller, params: params);
  }
}

class _MatchCounter extends StatelessWidget {
  const _MatchCounter({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (label.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 13, fontFeatures: const [FontFeature.tabularFigures()]),
      ),
    );
  }
}

/// The draggable scroll thumb: a rounded pill showing the current page (and total, once known), in
/// the app's panel styling so it reads as part of the UI rather than a stray browser scrollbar.
class _ScrollThumb extends StatelessWidget {
  const _ScrollThumb({required this.page, required this.pageCount});

  final int? page;
  final int? pageCount;

  @override
  Widget build(BuildContext context) {
    final label = page == null
        ? ''
        : (pageCount == null ? '$page' : '$page/$pageCount');
    return Container(
      decoration: BoxDecoration(
        color: context.cardBgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.accentColor.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: context.panelBorderColor,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(
          color: context.textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFeatures: const [FontFeature.tabularFigures()],
        ),
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
                  AppLocalizations.of(context).rulesDownloadingPercent((value * 100).round()),
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
