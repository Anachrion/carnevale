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

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// How the card viewer animates when turning a card over to reveal its back.
enum CardFlipStyle {
  /// Rotate the card around its vertical axis, like flipping a physical card.
  flip,

  /// Cross-slide: the front slides off one edge as the back slides in from the other.
  swipe,
}

/// When the app pre-downloads card face images to the on-device cache.
enum CardDownloadMode {
  /// Never bulk-download; a face is fetched (and then cached) only when it's actually viewed.
  /// The safe default — no surprise data usage on a metered connection.
  onDemand,

  /// Bulk-download missing/outdated faces on launch over any connection.
  always,

  /// Bulk-download on launch, but only while on Wi-Fi (skips cellular).
  wifiOnly,
}

class SettingsService extends ChangeNotifier {
  // Factory singleton, matching the other services (ApiClient/AuthService/GangService/…) so that
  // `SettingsService()` anywhere resolves to the same instance the `settingsService` global holds,
  // rather than silently constructing a second, listener-less copy.
  static final SettingsService _instance = SettingsService._();
  factory SettingsService() => _instance;
  SettingsService._();

  static const _themeKey = 'theme_mode';
  static const _cardFlipStyleKey = 'card_flip_style';
  static const _cardDownloadModeKey = 'card_download_mode';
  static const _localeKey = 'locale';

  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  // null = follow the device locale (MaterialApp resolves it against supportedLocales); a non-null
  // value pins the app to that language regardless of the device. Stored as the language code
  // ('en', 'fr'); an unrecognised/absent stored value falls back to null (system).
  Locale? _locale;
  Locale? get locale => _locale;

  CardFlipStyle _cardFlipStyle = CardFlipStyle.flip;
  CardFlipStyle get cardFlipStyle => _cardFlipStyle;

  CardDownloadMode _cardDownloadMode = CardDownloadMode.onDemand;
  CardDownloadMode get cardDownloadMode => _cardDownloadMode;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_themeKey);
    _themeMode = switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    _cardFlipStyle = switch (prefs.getString(_cardFlipStyleKey)) {
      'swipe' => CardFlipStyle.swipe,
      _ => CardFlipStyle.flip,
    };
    _cardDownloadMode = switch (prefs.getString(_cardDownloadModeKey)) {
      'always' => CardDownloadMode.always,
      'wifi_only' => CardDownloadMode.wifiOnly,
      _ => CardDownloadMode.onDemand,
    };
    final localeCode = prefs.getString(_localeKey);
    _locale = (localeCode == null || localeCode.isEmpty)
        ? null
        : Locale(localeCode);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await prefs.setString(_themeKey, value);
  }

  Future<void> setCardFlipStyle(CardFlipStyle style) async {
    _cardFlipStyle = style;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cardFlipStyleKey, style.name);
  }

  Future<void> setCardDownloadMode(CardDownloadMode mode) async {
    _cardDownloadMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final value = switch (mode) {
      CardDownloadMode.always => 'always',
      CardDownloadMode.wifiOnly => 'wifi_only',
      CardDownloadMode.onDemand => 'on_demand',
    };
    await prefs.setString(_cardDownloadModeKey, value);
  }

  /// Pins the app language, or passes null to follow the device locale.
  Future<void> setLocale(Locale? locale) async {
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_localeKey);
    } else {
      await prefs.setString(_localeKey, locale.languageCode);
    }
  }
}
