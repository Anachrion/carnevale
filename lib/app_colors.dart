import 'package:flutter/material.dart';

extension AppColors on BuildContext {
  bool get _isDark => Theme.of(this).brightness == Brightness.dark;

  Color get textColor =>
      _isDark ? const Color(0xFFEDE8DF) : const Color(0xFF2C2418);

  Color get subtleTextColor =>
      _isDark ? const Color(0xFFAA9E92) : const Color(0xFF7A6E62);

  Color get cardBgColor =>
      _isDark ? const Color(0xFF1E1C18) : const Color(0xFFF5F2EE);
}
