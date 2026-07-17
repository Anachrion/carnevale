// Copyright 2026 Anachrion
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_colors.dart';
import '../services/rules_service.dart';
import '../widgets/app_background.dart';
import '../widgets/app_drawer.dart';
import '../widgets/glass_panel.dart';
import '../widgets/screen_header.dart';
import '../widgets/status_views.dart';
import 'rules_document_screen.dart';

/// The Rules page: TT Combat's published rules PDFs, opened in an in-app viewer.
class RulesScreen extends StatefulWidget {
  const RulesScreen({super.key});

  @override
  State<RulesScreen> createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _service = RulesService();

  List<RulesDoc> _docs = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final docs = await _service.loadDocuments();
      if (!mounted) return;
      setState(() {
        _docs = docs;
        _loading = false;
      });
    } catch (e, st) {
      debugPrint('RulesScreen error: $e\n$st');
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _open(RulesDoc doc) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RulesDocumentScreen(doc: doc)),
    );
    // The viewer may have just downloaded the PDF, so the "offline" tick on its row is now stale.
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppPalette.background,
      drawer: const AppDrawer(current: AppDrawerRoute.rules),
      body: AppBackground(
        child: Column(
          children: [
            ScreenHeader(
              title: 'RULES',
              onMenu: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            Expanded(child: _body()),
          ],
        ),
      ),
    );
  }

  Widget _body() {
    if (_loading) return const LoadingView();
    if (_error != null) return ErrorRetryView(onRetry: _load);

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      itemCount: _docs.length + 1,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == _docs.length) return const _Attribution();
        final doc = _docs[index];
        return _DocumentTile(
          doc: doc,
          downloaded: _service.isDownloaded(doc),
          onTap: () => _open(doc),
        );
      },
    );
  }
}

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({
    required this.doc,
    required this.downloaded,
    required this.onTap,
  });

  final RulesDoc doc;
  final bool downloaded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 12, 18),
            child: Row(
              children: [
                Icon(
                  Icons.picture_as_pdf_outlined,
                  color: context.accentColor,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc.title,
                        style: GoogleFonts.cinzel(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: context.textColor,
                        ),
                      ),
                      // Only worth saying on mobile — the web build streams from the CDN and never
                      // holds a copy, so every row would permanently read "not available offline".
                      if (!kIsWeb) ...[
                        const SizedBox(height: 4),
                        Text(
                          downloaded ? 'Available offline' : 'Downloads on first open',
                          style: TextStyle(
                            fontSize: 12,
                            color: context.subtleTextColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (!kIsWeb && downloaded)
                  Icon(
                    Icons.offline_pin_outlined,
                    size: 18,
                    color: context.subtleTextColor,
                  ),
                Icon(Icons.chevron_right, color: context.accentColor, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Attribution extends StatelessWidget {
  const _Attribution();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
      child: Text(
        'Rules PDFs are published by TT Combat and served from their site. '
        'Carnevale is © TT Combat.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, color: context.subtleTextColor),
      ),
    );
  }
}
