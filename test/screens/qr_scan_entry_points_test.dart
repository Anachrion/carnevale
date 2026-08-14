import 'package:built_value/serializer.dart';
import 'package:carnevale/screens/game_home_screen.dart';
import 'package:carnevale/screens/gangs_screen.dart';
import 'package:carnevale/services/auth_service.dart';
import 'package:carnevale/widgets/gang_text_dialogs.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../support/fake_api.dart';
import '../support/l10n.dart';

/// The QR scanner's edges (CARNEVALEB-74). The camera itself cannot run in a widget test, so what
/// is covered here is everything around it: that the ways in exist, and that a scanned gang lands
/// somewhere the user can see and check it before it becomes a list.
void main() {
  const gangText =
      'Carnevale gang: The Rooks\n'
      'Faction: guild\n'
      'Ducats: 150\n'
      '\n'
      'Models\n'
      '- Bravo\n';

  void signIn() => AuthService().debugLogin(
    const AuthUser(id: 1, email: 'a@b.c', username: 'tester'),
  );

  void stubGangs(FakeApiAdapter adapter) => adapter.stub(
    'GET',
    '/lists',
    listBody<api.ModelList>([
      fakeModelList(name: 'The Rooks'),
    ], const FullType(api.ModelList)),
  );

  testWidgets('the gangs screen offers scanning beside importing', (
    tester,
  ) async {
    signIn();
    stubGangs(installFakeApi());

    await tester.pumpWidget(localizedApp(home: GangsScreen()));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.qr_code_scanner), findsOneWidget);
    // Scanning does not replace pasting: a gang also arrives by chat message.
    expect(find.byIcon(Icons.file_download), findsOneWidget);
  });

  testWidgets('the games screen offers scanning', (tester) async {
    signIn();
    installFakeApi().stub(
      'GET',
      '/games',
      listBody<api.Game>([], const FullType(api.Game)),
    );

    await tester.pumpWidget(localizedApp(home: const GameHomeScreen()));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.qr_code_scanner), findsOneWidget);
  });

  // The contract that matters for a scan: a gang read off a camera is *shown*, not imported behind
  // the user's back. A scanner is easy to aim at the wrong sheet of paper.
  testWidgets('a scanned gang opens the import sheet pre-filled, not imported', (
    tester,
  ) async {
    signIn();
    final adapter = installFakeApi();
    stubGangs(adapter);

    await tester.pumpWidget(
      localizedApp(home: GangsScreen(initialImportText: gangText)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Import a gang'), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller?.text,
      gangText,
    );
    // Still waiting on the user: nothing was sent.
    expect(find.text('Import'), findsOneWidget);
  });

  testWidgets('without a scan the import sheet stays closed', (tester) async {
    signIn();
    stubGangs(installFakeApi());

    await tester.pumpWidget(localizedApp(home: GangsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Import a gang'), findsNothing);
  });

  // QrImageView keeps its payload private, so what the code *carries* is pinned on the function the
  // widget feeds from rather than on the widget.
  group('gangQrPayload', () {
    test('is the exported text itself, unwrapped', () {
      expect(gangQrPayload(gangText), gangText);
    });

    test('gives up past the readable size, rather than drawing a dense code', () {
      final huge = 'x' * (gangQrMaxBytes + 1);
      expect(gangQrPayload(huge), isNull);
      expect(gangQrPayload('x' * gangQrMaxBytes), isNotNull);
    });

    // Bytes, not characters: the encoder fits bytes, and a gang named in French spends two per
    // accent. Measuring in characters would let an accented gang overflow the code it was cleared
    // for.
    test('counts bytes, not characters', () {
      final accented = 'é' * gangQrMaxBytes;
      expect(accented.length, gangQrMaxBytes);
      expect(gangQrPayload(accented), isNull);
    });
  });

  group('the export dialog QR', () {
    Future<void> openExport(WidgetTester tester, String text) async {
      final adapter = installFakeApi();
      adapter.stub('GET', '/lists/1/export', {'text': text});
      await tester.pumpWidget(
        localizedApp(
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () => showGangExportDialog(context, 1),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
    }

    testWidgets('renders the gang text, and swaps back', (tester) async {
      signIn();
      await openExport(tester, gangText);

      expect(find.byType(QrImageView), findsNothing);
      await tester.tap(find.text('QR code'));
      await tester.pumpAndSettle();

      expect(find.byType(QrImageView), findsOneWidget);
      expect(find.text('Scan to import'), findsOneWidget);

      await tester.tap(find.text('Export gang').last);
      await tester.pumpAndSettle();
      expect(find.byType(QrImageView), findsNothing);
    });

    // The QR button made this a three-button row where it had been two. A dialog is narrow, the
    // labels are words rather than icons, and an overflow here would only ever be seen on a real
    // phone — so the row is asserted at a small phone's width, not at the test default of 800.
    testWidgets('the action row fits a narrow phone', (tester) async {
      signIn();
      tester.view.physicalSize = const Size(320 * 3, 640 * 3);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await openExport(tester, gangText);

      expect(tester.takeException(), isNull);
      expect(find.text('QR code'), findsOneWidget);
      expect(find.text('Copy'), findsOneWidget);
    });

    // Past the measured readable size the dialog says so rather than drawing a code too dense to
    // scan, which would fail silently in the one place the user cannot tell why.
    testWidgets('refuses a gang too long to scan', (tester) async {
      signIn();
      final huge = '$gangText${'- Bravo\n' * 400}';
      expect(huge.length, greaterThan(gangQrMaxBytes));
      await openExport(tester, huge);

      await tester.tap(find.text('QR code'));
      await tester.pumpAndSettle();

      expect(find.byType(QrImageView), findsNothing);
      expect(find.textContaining('too long'), findsOneWidget);
      // The text is still one tap away — the format is the text, the code is a convenience.
      expect(find.text('Copy'), findsOneWidget);
    });
  });
}
