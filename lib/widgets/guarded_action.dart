import 'package:flutter/material.dart';

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
      showAppToast(context, 'Something went wrong. Please try again.');
    }
    return false;
  }
}
