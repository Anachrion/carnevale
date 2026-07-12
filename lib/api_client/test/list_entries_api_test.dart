import 'package:test/test.dart';
import 'package:carnevale_api/carnevale_api.dart';

/// tests for ListEntriesApi
void main() {
  final instance = CarnevaleApi().getListEntriesApi();

  group(ListEntriesApi, () {
    // Add a card to a list
    //
    //Future<BuiltList> createListEntry(int listId, EntryInput entryInput) async
    test('test createListEntry', () async {
      // TODO
    });

    // Remove a card from a list
    //
    //Future<BuiltList> deleteListEntry(int listId, int id) async
    test('test deleteListEntry', () async {
      // TODO
    });
  });
}
