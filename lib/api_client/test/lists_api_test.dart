import 'package:test/test.dart';
import 'package:carnevale_api/carnevale_api.dart';


/// tests for ListsApi
void main() {
  final instance = CarnevaleApi().getListsApi();

  group(ListsApi, () {
    // Create a list
    //
    //Future<BuiltList> createList(ListInput listInput) async
    test('test createList', () async {
      // TODO
    });

    // Delete a list
    //
    //Future deleteList(int id) async
    test('test deleteList', () async {
      // TODO
    });

    // Get a list
    //
    //Future<BuiltList> getList(int id) async
    test('test getList', () async {
      // TODO
    });

    // List all lists
    //
    //Future<BuiltList<BuiltList>> getLists() async
    test('test getLists', () async {
      // TODO
    });

    // Update a list
    //
    //Future<BuiltList> updateList(int id, ListInput listInput) async
    test('test updateList', () async {
      // TODO
    });

  });
}
