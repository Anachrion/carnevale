import 'package:test/test.dart';
import 'package:carnevale_api/carnevale_api.dart';

// tests for CardManifestEntry
void main() {
  final instance = CardManifestEntryBuilder();
  // TODO add properties to the builder and call build()

  group(CardManifestEntry, () {
    // String identifier
    test('to test the property `identifier`', () async {
      // TODO
    });

    // String faction
    test('to test the property `faction`', () async {
      // TODO
    });

    // Bumps whenever the card's image bytes change; drives client re-download.
    // int internalVersion
    test('to test the property `internalVersion`', () async {
      // TODO
    });

    // Versioned (?v=internal_version) URL of the front image, or null if missing.
    // String frontUrl
    test('to test the property `frontUrl`', () async {
      // TODO
    });

    // String backUrl
    test('to test the property `backUrl`', () async {
      // TODO
    });

    // Size in bytes of the front image, or null if the file is missing.
    // int frontBytes
    test('to test the property `frontBytes`', () async {
      // TODO
    });

    // int backBytes
    test('to test the property `backBytes`', () async {
      // TODO
    });
  });
}
