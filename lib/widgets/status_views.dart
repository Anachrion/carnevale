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

import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../l10n/app_localizations.dart';

/// The shared full-body status placeholders (F-P2-3): the gold spinner, the "could not reach
/// server" retry block, and the logged-out prompt — previously copy-pasted verbatim across the
/// gangs, games and session screens.

/// Centered gold progress spinner shown while a screen's data loads.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: context.accentColor),
    );
  }
}

/// A wifi-off icon, a message and a "Retry" button. [message] defaults to the common
/// server-unreachable copy (localized); pass a specific error string to override it.
class ErrorRetryView extends StatelessWidget {
  const ErrorRetryView({
    super.key,
    required this.onRetry,
    this.message,
  });

  final VoidCallback onRetry;
  // Nullable so the default can be localized in build — a const default can't call
  // AppLocalizations.of(context).
  final String? message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off, size: 40, color: context.subtleTextColor),
          const SizedBox(height: 12),
          Text(message ?? l10n.errorCouldNotReachServer,
              style: TextStyle(color: context.subtleTextColor)),
          const SizedBox(height: 8),
          TextButton(onPressed: onRetry, child: Text(l10n.actionRetry)),
        ],
      ),
    );
  }
}

/// A lock icon, a prompt and a gold "Log In" button. [onLogin] typically pushes the account screen.
class LoggedOutView extends StatelessWidget {
  const LoggedOutView({
    super.key,
    required this.message,
    required this.onLogin,
  });

  final String message;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, size: 40, color: context.subtleTextColor),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.subtleTextColor),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.accentColor,
                foregroundColor: Colors.white,
              ),
              child: Text(AppLocalizations.of(context).actionLogIn),
            ),
          ],
        ),
      ),
    );
  }
}
