import 'package:carnevale/widgets/token_chip.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

api.Token _token({
  String? text,
  bool active = true,
  bool toggleable = false,
  api.TokenColorEnum color = api.TokenColorEnum.crimson,
}) => api.Token(
  (b) => b
    ..id = 't1'
    ..color = color
    ..text = text
    ..toggleable = toggleable
    ..active = active,
);

void main() {
  Widget host(Widget child) =>
      MaterialApp(home: Scaffold(body: Center(child: child)));

  Finder textIn(Finder chip) =>
      find.descendant(of: chip, matching: find.byType(Text));
  Finder opacityIn(Finder chip) =>
      find.descendant(of: chip, matching: find.byType(Opacity));

  testWidgets('a labelled token shows its label; a colour-only token shows none', (
    tester,
  ) async {
    await tester.pumpWidget(host(TokenChip(token: _token(text: 'Pulse'))));
    expect(find.text('Pulse'), findsOneWidget);

    await tester.pumpWidget(host(TokenChip(token: _token())));
    expect(textIn(find.byType(TokenChip)), findsNothing);
  });

  testWidgets('an inactive (toggleable) token is dimmed; an active one is not', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(TokenChip(token: _token(text: 'Aura', toggleable: true, active: false))),
    );
    expect(
      tester.widget<Opacity>(opacityIn(find.byType(TokenChip))).opacity,
      lessThan(1),
    );

    await tester.pumpWidget(
      host(TokenChip(token: _token(text: 'Aura', toggleable: true, active: true))),
    );
    expect(
      tester.widget<Opacity>(opacityIn(find.byType(TokenChip))).opacity,
      1,
    );
  });

  testWidgets('tapping a token fires onTap', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      host(TokenChip(token: _token(text: 'Pulse'), onTap: () => tapped = true)),
    );
    await tester.tap(find.byType(TokenChip));
    expect(tapped, isTrue);
  });
}
