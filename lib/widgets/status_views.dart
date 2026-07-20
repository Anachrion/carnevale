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
