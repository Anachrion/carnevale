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

import 'game_setup.dart';

/// What something arriving from outside the app turns out to point at (CARNEVALEB-74).
///
/// Two doors lead in — an OS deep link and the QR scanner — and they must agree on what a payload
/// means. Parsed in one place so they cannot drift: a `/join` link that stopped opening the join
/// sheet only when scanned would be a genuinely puzzling bug.
sealed class ScanTarget {
  const ScanTarget();
}

/// `/reset-password?reset_password_token=…`, as sent by the password-reset email.
final class ResetPasswordTarget extends ScanTarget {
  const ResetPasswordTarget(this.token);
  final String token;
}

/// `/join?code=…` — an invitation to someone else's game.
final class JoinGameTarget extends ScanTarget {
  const JoinGameTarget(this.code);
  final String code;
}

/// `/new-game?…` — settings agreed in advance, for whoever ends up hosting.
final class NewGameTarget extends ScanTarget {
  const NewGameTarget(this.setup);
  final GameSetup setup;
}

/// A gang in the plain-text exchange format, to import as a new list.
final class GangTextTarget extends ScanTarget {
  const GangTextTarget(this.text);
  final String text;
}

/// The first line of an exported gang (`Gang::TextFormat::HEADER_KEY` on the server).
///
/// The server's parser is deliberately lenient and does not require this line, but *recognition* is
/// a different job from parsing: something has to say "this blob is a gang and not a Wi-Fi QR"
/// before anything is parsed at all. Our own export always writes it, so it is a reliable sentinel
/// for anything we produced. A hand-typed list missing the header simply is not offered by the
/// scanner — it can still be pasted into the import sheet, which parses rather than recognises.
const _gangTextHeader = 'Carnevale gang:';

/// What a URI opened from outside points at, or null if nothing we serve.
///
/// Matching is on the **path alone**; the host is ignored. Nothing here is ever fetched — only the
/// path and query are read, and every destination is an internal screen — so a foreign host cannot
/// send the app anywhere. Ignoring it is what keeps links from a dev or staging build working.
ScanTarget? targetForUri(Uri uri) {
  switch (uri.path) {
    case '/reset-password':
      final token = uri.queryParameters['reset_password_token'];
      return (token == null || token.isEmpty)
          ? null
          : ResetPasswordTarget(token);
    case '/join':
      final code = uri.queryParameters['code'];
      return (code == null || code.isEmpty) ? null : JoinGameTarget(code);
    case GameSetup.path:
      final setup = GameSetup.fromUri(uri);
      return setup == null ? null : NewGameTarget(setup);
    default:
      return null;
  }
}

/// What a scanned QR payload points at, or null if it is not ours to act on.
///
/// A narrower door than [targetForUri] on purpose: a QR is picked up off an arbitrary physical
/// surface, whereas a deep link is followed from a place the user already trusts. Only the three
/// things worth handing over in person are accepted — join a game, start one from shared settings,
/// import a gang.
///
/// [ResetPasswordTarget] is deliberately refused. A reset link arrives by email and has no reason
/// to be on a poster: honouring one from a QR would let someone hand you *their* reset token and
/// have you set a password on their account, believing it was yours.
ScanTarget? targetForScan(String raw) {
  final payload = raw.trim();
  if (payload.isEmpty) return null;
  if (payload.startsWith(_gangTextHeader)) return GangTextTarget(payload);

  // Note Uri.parse is no filter here: it accepts almost anything, reading "wifi stuff" as a
  // relative URI whose path is "wifi%20stuff". What rejects a foreign QR is the path not matching
  // a route below, not the parse failing — which is why tryParse's null case is barely the point.
  final uri = Uri.tryParse(payload);
  final target = uri == null ? null : targetForUri(uri);
  return switch (target) {
    JoinGameTarget() || NewGameTarget() => target,
    _ => null,
  };
}
