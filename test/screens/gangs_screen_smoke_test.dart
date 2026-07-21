import 'package:built_value/serializer.dart';
import 'package:carnevale/screens/gangs_screen.dart';
import 'package:carnevale/services/auth_service.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';
import '../support/l10n.dart';

void main() {
  testWidgets('GangsScreen renders the current user\'s gangs from the API', (
    tester,
  ) async {
    AuthService().debugLogin(
      const AuthUser(id: 1, email: 'a@b.c', username: 'tester'),
    );
    final adapter = installFakeApi();
    adapter.stub(
      'GET',
      '/lists',
      listBody<api.ModelList>([
        fakeModelList(name: 'The Rooks'),
        fakeModelList(id: 2, name: 'Canal Crows'),
      ], const FullType(api.ModelList)),
    );

    await tester.pumpWidget(localizedApp(home: GangsScreen()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('The Rooks'), findsWidgets);
    expect(find.text('Canal Crows'), findsWidgets);
  });
}
