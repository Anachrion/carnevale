import 'dart:ui';
import 'package:flutter/material.dart';
import '../app_colors.dart';

class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  final Widget child;

  /// Inner padding around [child]. Pass [EdgeInsets.zero] when the child manages its own insets
  /// (e.g. a `Material`/`InkWell` tappable row or a bare `TextField`).
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: BoxDecoration(
            gradient: context.panelGradient,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: context.panelBorderColor, width: 1.0),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
