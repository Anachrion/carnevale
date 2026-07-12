import 'package:test/test.dart';
import 'package:carnevale_api/carnevale_api.dart';

/// tests for CardsApi
void main() {
  final instance = CarnevaleApi().getCardsApi();

  group(CardsApi, () {
    // Card image sync manifest (identifier, internal_version, download URLs)
    //
    // One entry per card with its current internal_version and the versioned URLs to download its front/back images. Clients cache images locally and re-download only cards whose internal_version is higher than the cached one. Card stats come from /profiles.
    //
    //Future<GetCardsManifest200Response> getCardsManifest({ String faction }) async
    test('test getCardsManifest', () async {
      // TODO
    });
  });
}
