import 'package:built_value/serializer.dart';
import 'package:carnevale/screens/cards_screen.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';
import '../support/l10n.dart';

void main() {
  testWidgets('CardsScreen loads and renders profiles from the API', (
    tester,
  ) async {
    final adapter = installFakeApi();
    adapter.stub(
      'GET',
      '/profiles',
      listBody<api.Profile>([
        fakeProfile(name: 'Capodecina'),
        fakeProfile(id: 2, name: 'Bombardier'),
      ], const FullType(api.Profile)),
    );

    await tester.pumpWidget(localizedApp(home: CardsScreen()));
    // Let the initial _load() future resolve and the list rebuild.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Capodecina'), findsOneWidget);
    expect(find.text('Bombardier'), findsOneWidget);
  });
}
