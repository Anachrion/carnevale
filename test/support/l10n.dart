import 'package:carnevale/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// A [MaterialApp] wired with the app's localization delegates, for tests that pump a widget
/// calling `AppLocalizations.of(context)`.
///
/// l10n.yaml sets `nullable-getter: false`, so `AppLocalizations.of` null-asserts its lookup: under
/// a bare `MaterialApp` there is no AppLocalizations in the tree and the widget throws while
/// building rather than falling back to English.
///
/// The locale is pinned to English rather than left to the device so `find.text` expectations stay
/// stable — pass [locale] explicitly to assert on a translation.
MaterialApp localizedApp({
  required Widget home,
  Locale locale = const Locale('en'),
}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: home,
  );
}
