import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _kGold = Color(0xFFC4A050);

void showAppToast(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _AppToast(message: message, onDismissed: () => entry.remove()),
  );
  overlay.insert(entry);
}

class _AppToast extends StatefulWidget {
  const _AppToast({required this.message, required this.onDismissed});

  final String message;
  final VoidCallback onDismissed;

  @override
  State<_AppToast> createState() => _AppToastState();
}

class _AppToastState extends State<_AppToast> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
    Future.delayed(const Duration(milliseconds: 1800), () async {
      if (!mounted) return;
      await _controller.reverse();
      widget.onDismissed();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 24,
      right: 24,
      child: IgnorePointer(
        child: FadeTransition(
          opacity: _opacity,
          child: Material(
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: (isDark ? const Color(0xFF1A1612) : const Color(0xFFF5F2EE))
                        .withValues(alpha: 0.92),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _kGold.withValues(alpha: 0.6), width: 1.2),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 4)),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle, color: _kGold, size: 20),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          widget.message,
                          style: GoogleFonts.cinzel(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: isDark ? const Color(0xFFEDE8DF) : const Color(0xFF2C2418),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
