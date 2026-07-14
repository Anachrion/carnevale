import 'package:test/test.dart';
import 'package:carnevale_api/carnevale_api.dart';


/// tests for RulesApi
void main() {
  final instance = CarnevaleApi().getRulesApi();

  group(RulesApi, () {
    // List the rules PDFs the app's Rules page offers, in display order
    //
    // Links to TT Combat's own published PDFs. The URLs carry a Shopify `?v=` cache buster that changes whenever a document is re-uploaded, so a client that caches a file should re-download it when the URL for a `key` differs from the one it cached. 
    //
    //Future<BuiltList<RulesDocument>> getRulesDocuments() async
    test('test getRulesDocuments', () async {
      // TODO
    });

  });
}
