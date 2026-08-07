import 'package:built_value/serializer.dart';
import 'package:carnevale/screens/gangs_screen.dart';
import 'package:carnevale/services/auth_service.dart';
import 'package:carnevale/widgets/gang_text_dialogs.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';
import '../support/l10n.dart';

/// The plain-text gang exchange (CARNEVALEB-74). The format itself is the server's and is covered
/// there; these cover what the app owes the user around it — chiefly that a partial import cannot
/// pass unnoticed.
void main() {
  const exported =
      'Carnevale gang: The Rooks\n'
      'Faction: guild\n'
      'Ducats: 150\n'
      '\n'
      'Models\n'
      '- Bravo\n';

  void signIn() => AuthService().debugLogin(
    const AuthUser(id: 1, email: 'a@b.c', username: 'tester'),
  );

  testWidgets('the export dialog shows the gang as text', (tester) async {
    signIn();
    final adapter = installFakeApi();
    adapter.stub('GET', '/lists/1/export', {'text': exported});

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

    expect(find.text('Export gang'), findsOneWidget);
    expect(find.textContaining('Carnevale gang: The Rooks'), findsOneWidget);
    expect(find.text('Copy'), findsOneWidget);
  });

  // The contract that matters: import succeeds partially by design, so anything the server could
  // not resolve has to reach the screen. A gang that arrives three models short without saying so
  // is the failure this guards against.
  testWidgets('a partial import reports what was skipped', (tester) async {
    signIn();
    final adapter = installFakeApi();
    adapter.stub('POST', '/lists/import', {
      'list': modelListBody(fakeModelList(name: 'The Rooks')),
      'warnings': ["unknown model 'Nonesuch'"],
    });

    api.ModelList? returned;
    await tester.pumpWidget(
      localizedApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async => returned = await showGangImportSheet(context),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), exported);
    await tester.tap(find.text('Import'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Nonesuch'), findsOneWidget);
    expect(find.text('1 line skipped'), findsOneWidget);
    // Still open, and Import is gone: tapping it again would build a second copy of the same gang.
    expect(find.text('Import'), findsNothing);
    expect(find.text('Done'), findsOneWidget);
    expect(returned, isNull);

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(returned?.name, 'The Rooks');
  });

  testWidgets('a clean import closes straight away', (tester) async {
    signIn();
    final adapter = installFakeApi();
    adapter.stub('POST', '/lists/import', {
      'list': modelListBody(fakeModelList(name: 'Canal Crows')),
      'warnings': <String>[],
    });

    api.ModelList? returned;
    await tester.pumpWidget(
      localizedApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async => returned = await showGangImportSheet(context),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), exported);
    await tester.tap(find.text('Import'));
    await tester.pumpAndSettle();

    expect(returned?.name, 'Canal Crows');
  });

  testWidgets('the gangs screen offers the import action', (tester) async {
    signIn();
    final adapter = installFakeApi();
    adapter.stub(
      'GET',
      '/lists',
      listBody<api.ModelList>([
        fakeModelList(name: 'The Rooks'),
      ], const FullType(api.ModelList)),
    );

    await tester.pumpWidget(localizedApp(home: GangsScreen()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.byIcon(Icons.file_download), findsOneWidget);
  });
}
