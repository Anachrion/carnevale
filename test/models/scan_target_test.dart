import 'package:carnevale/models/scan_target.dart';
import 'package:flutter_test/flutter_test.dart';

/// What the app agrees to act on when something arrives from outside (CARNEVALEB-74).
///
/// Both doors — an OS deep link and the QR scanner — resolve through here, and they accept
/// deliberately different sets. That difference is the security-relevant part of the feature, so it
/// is pinned rather than left to the reader of two call sites.
void main() {
  const gangText =
      'Carnevale gang: The Rooks\n'
      'Faction: guild\n'
      'Ducats: 150\n'
      '\n'
      'Models\n'
      '- Bravo\n';

  group('targetForUri', () {
    test('reads a join code', () {
      final target = targetForUri(
        Uri.parse('https://carnevale-app.com/join?code=XYZ789'),
      );
      expect(target, isA<JoinGameTarget>());
      expect((target as JoinGameTarget).code, 'XYZ789');
    });

    test('reads a shared setup', () {
      final target = targetForUri(
        Uri.parse('https://carnevale-app.com/new-game?scenario=Gang%20War'),
      );
      expect(target, isA<NewGameTarget>());
      expect((target as NewGameTarget).setup.scenarioName, 'Gang War');
    });

    test('reads a password-reset token', () {
      final target = targetForUri(
        Uri.parse('https://carnevale-app.com/reset-password?reset_password_token=tok'),
      );
      expect(target, isA<ResetPasswordTarget>());
      expect((target as ResetPasswordTarget).token, 'tok');
    });

    // The host is never fetched — only the path and query are read — so ignoring it costs nothing
    // and is what keeps a link produced by a dev or staging build working.
    test('ignores the host, matching on the path alone', () {
      expect(
        targetForUri(Uri.parse('http://10.0.2.2:3000/join?code=ABC')),
        isA<JoinGameTarget>(),
      );
    });

    test('refuses paths it does not serve, and empty values', () {
      expect(targetForUri(Uri.parse('https://carnevale-app.com/cards')), isNull);
      expect(targetForUri(Uri.parse('https://carnevale-app.com/join')), isNull);
      expect(targetForUri(Uri.parse('https://carnevale-app.com/join?code=')), isNull);
      // A bare /new-game carries no settings: an empty form is not a shared setup.
      expect(targetForUri(Uri.parse('https://carnevale-app.com/new-game')), isNull);
      expect(
        targetForUri(Uri.parse('https://carnevale-app.com/reset-password')),
        isNull,
      );
    });
  });

  group('targetForScan', () {
    test('accepts the three things worth handing over in person', () {
      expect(
        targetForScan('https://carnevale-app.com/join?code=XYZ789'),
        isA<JoinGameTarget>(),
      );
      expect(
        targetForScan('https://carnevale-app.com/new-game?ducats=200'),
        isA<NewGameTarget>(),
      );
      final gang = targetForScan(gangText);
      expect(gang, isA<GangTextTarget>());
      expect((gang as GangTextTarget).text, gangText.trim());
    });

    // The point of the narrower door. A reset link belongs in an email; honouring one off a poster
    // would let someone hand you *their* token and have you set a password on their account.
    test('refuses a password-reset link, which a deep link still accepts', () {
      const url =
          'https://carnevale-app.com/reset-password?reset_password_token=tok';
      expect(targetForUri(Uri.parse(url)), isA<ResetPasswordTarget>());
      expect(targetForScan(url), isNull);
    });

    test('refuses codes that are not ours', () {
      expect(targetForScan('WIFI:S=CafeNet;T=WPA;P=hunter2;;'), isNull);
      expect(targetForScan('https://example.com/'), isNull);
      expect(targetForScan('just some words'), isNull);
      expect(targetForScan(''), isNull);
      expect(targetForScan('   '), isNull);
    });

    // Uri.parse is no filter: it reads "just some words" as a relative URI whose path is
    // "just%20some%20words". What rejects a foreign code is the path not matching a route, which is
    // why the case above passes — this pins the reasoning so the check is not "simplified" into a
    // try/catch around the parse.
    test('a non-URL payload parses fine and is still refused', () {
      expect(Uri.tryParse('just some words'), isNotNull);
      expect(targetForScan('just some words'), isNull);
    });

    test('recognises a gang by its header, not by looking like text', () {
      expect(targetForScan('Faction: guild\nDucats: 150\n'), isNull);
      // Leading whitespace from a hand-assembled payload should not defeat recognition.
      expect(targetForScan('\n  $gangText'), isA<GangTextTarget>());
    });
  });
}
