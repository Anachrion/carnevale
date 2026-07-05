import 'dart:ui';
import 'package:flutter/material.dart';
import '../app_colors.dart';

class GlassPanel extends StatelessWidget {
  const GlassPanel({super.key, required this.child});
  final Widget child;

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
            border: Border.all(
              color: context.panelBorderColor,
              width: 1.0,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: child,
        ),
      ),
    );
  }
}
