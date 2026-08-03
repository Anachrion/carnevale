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

import '../l10n/app_localizations.dart';
import '../services/api_exception.dart';
import 'app_toast.dart';

/// Runs [action], surfacing any failure as a toast instead of letting it vanish silently.
///
/// The services throw [ApiException] with a human-readable, backend-supplied message (e.g. "Gangs
/// can no longer be changed", a field validation error); that message is shown as-is. Anything else
/// falls back to a generic message. Returns true when the action completed, false when it threw —
/// so callers that need to react to failure (e.g. rolling back an optimistic UI change, or holding
/// off an animation) can branch on the result.
///
/// The [context] is captured before the await; callers must still guard their own post-await
/// `setState`/navigation with `mounted`, exactly as before.
Future<bool> guard(BuildContext context, Future<void> Function() action) async {
  try {
    await action();
    return true;
  } on ApiException catch (e) {
    if (context.mounted) showAppToast(context, e.message);
    return false;
  } catch (_) {
    if (context.mounted) {
      showAppToast(context, AppLocalizations.of(context).errorGeneric);
    }
    return false;
  }
}
