import 'package:test/test.dart';
import 'package:carnevale_api/carnevale_api.dart';


/// tests for EntriesApi
void main() {
  final instance = CarnevaleApi().getEntriesApi();

  group(EntriesApi, () {
    // Add a card to a list
    //
    //Future<BuiltList> createEntry(int listId, EntryInput entryInput) async
    test('test createEntry', () async {
      // TODO
    });

    // Remove a card from a list
    //
    //Future<BuiltList> deleteEntry(int listId, int id) async
    test('test deleteEntry', () async {
      // TODO
    });

  });
}
