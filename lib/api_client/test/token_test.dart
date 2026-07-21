import 'package:test/test.dart';
import 'package:carnevale_api/carnevale_api.dart';

// tests for Token
void main() {
  final instance = TokenBuilder();
  // TODO add properties to the builder and call build()

  group(Token, () {
    // Client-generated stable id; re-sending the same id updates the token instead of adding a duplicate.
    // String id
    test('to test the property `id`', () async {
      // TODO
    });

    // String color
    test('to test the property `color`', () async {
      // TODO
    });

    // Optional label; a colour-only token omits it and renders as a dot.
    // String text
    test('to test the property `text`', () async {
      // TODO
    });

    // Whether the player can flip it on/off (a recurring effect) rather than only add/remove it.
    // bool toggleable
    test('to test the property `toggleable`', () async {
      // TODO
    });

    // bool active
    test('to test the property `active`', () async {
      // TODO
    });

  });
}
