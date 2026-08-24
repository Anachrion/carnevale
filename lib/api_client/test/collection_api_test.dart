import 'package:test/test.dart';
import 'package:carnevale_api/carnevale_api.dart';


/// tests for CollectionApi
void main() {
  final instance = CarnevaleApi().getCollectionApi();

  group(CollectionApi, () {
    // The current player's collection
    //
    // One entry per catalog profile the player owns at least one miniature of. A profile absent from the response is simply one they own none of — there is no zeroed entry to read. 
    //
    //Future<BuiltList<CollectionItem>> getCollection() async
    test('test getCollection', () async {
      // TODO
    });

    // Set the counts for several profiles at once
    //
    // All or nothing: if any entry names a profile that does not exist, none of the others are applied either, so the client never has to work out how far a half-applied batch got. 
    //
    //Future<BuiltList<CollectionItem>> updateCollection(CollectionBulkInput collectionBulkInput) async
    test('test updateCollection', () async {
      // TODO
    });

    // Set the counts for one profile
    //
    // Send just the count that moved and the other two settle around it. The three nest as `painted <= built <= owned`, so raising a narrower count pulls the wider ones up with it, and lowering a wider one pushes the narrower ones down. The values are absolute, never increments, so replaying a request the client never saw the answer to is a no-op. Setting every count to zero drops the profile from the collection; the response still reports the resulting zeros so the client can reconcile without a second request. 
    //
    //Future<CollectionItem> updateCollectionItem(int profileId, CollectionItemInput collectionItemInput) async
    test('test updateCollectionItem', () async {
      // TODO
    });

  });
}
