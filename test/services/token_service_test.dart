import 'package:carnevale/services/game_service.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('upsertToken sends a token and parses the returned state', () async {
    final adapter = installFakeApi();
    final token = api.Token(
      (b) => b
        ..id = 'x'
        ..color = api.TokenColorEnum.crimson
        ..text = 'Pulse'
        ..toggleable = true
        ..active = true,
    );
    final state = fakeEntryState().rebuild((b) => b..tokens.add(token));
    adapter.stub('PATCH', '/games/1/entries/230/tokens', entryStateBody(state));

    final result = await GameService().upsertToken(
      1,
      230,
      tokenId: 'x',
      color: api.TokenColorEnum.crimson,
      text: 'Pulse',
      toggleable: true,
      active: true,
    );
    expect(result.tokens.length, 1);
    expect(result.tokens.first.text, 'Pulse');
  });
}
