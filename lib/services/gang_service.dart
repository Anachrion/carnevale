import 'package:built_collection/built_collection.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:dio/dio.dart';
import 'api_client.dart';
import 'api_exception.dart';

class GangService {
  static final GangService _instance = GangService._();
  factory GangService() => _instance;
  GangService._();

  final _client = ApiClient();

  // Wraps a call so a DioException surfaces as a uniform, user-presentable ApiException (F-P2-2).
  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      throw ApiException.from(e);
    }
  }

  Future<List<api.ModelList>> loadAll() => _guard(() async {
    final res = await _client.lists.getLists();
    return res.data?.toList() ?? [];
  });

  Future<api.ModelList> loadOne(int id) => _guard(() async {
    final res = await _client.lists.getList(id: id);
    return res.data!;
  });

  Future<api.ModelList> create(String name, String faction, int points) =>
      _guard(() async {
        final res = await _client.lists.createList(
          listInput: api.ListInput(
            (b) => b
              ..list = api.ListInputList(
                (lb) => lb
                  ..name = name
                  ..faction = faction
                  ..points = points,
              ).toBuilder(),
          ),
        );
        return res.data!;
      });

  Future<void> delete(int id) => _guard(() async {
    await _client.lists.deleteList(id: id);
  });

  Future<api.ModelList> addEntry(int listId, int entryId, String entryType) =>
      _guard(() async {
        final typeEnum = entryType == 'Equipment'
            ? api.EntryInputEntryEntryTypeEnum.catalogColonColonEquipment
            : api.EntryInputEntryEntryTypeEnum.catalogColonColonCardReference;
        final res = await _client.listEntries.createListEntry(
          entryInput: api.EntryInput(
            (b) => b
              ..entry = api.EntryInputEntry(
                (eb) => eb
                  ..listId = listId
                  ..entryType = typeEnum
                  ..entryId = entryId,
              ).toBuilder(),
          ),
        );
        return res.data!;
      });

  Future<api.ModelList> removeEntry(int entryId) => _guard(() async {
    final res = await _client.listEntries.deleteListEntry(id: entryId);
    return res.data!;
  });

  Future<api.ModelList> reorderEntry(int entryId, int position) =>
      _guard(() async {
        final res = await _client.listEntries.updateListEntryPosition(
          id: entryId,
          entryPositionInput: api.EntryPositionInput(
            (b) => b
              ..entry = api.EntryPositionInputEntry(
                (eb) => eb..position = position,
              ).toBuilder(),
          ),
        );
        return res.data!;
      });

  /// Replaces a Mage model's committed Discipline and full set of known spells (rulebook p24).
  Future<api.ModelList> setEntrySpells(
    int entryId,
    String? discipline,
    List<int> spellIds,
  ) => _guard(() async {
    final res = await _client.listEntries.setListEntrySpells(
      id: entryId,
      setEntrySpellsInput: api.SetEntrySpellsInput(
        (b) => b
          ..entry = api.SetEntrySpellsInputEntry(
            (eb) => eb
              ..discipline = _disciplineEnum(discipline)
              ..spellIds = ListBuilder<int>(spellIds),
          ).toBuilder(),
      ),
    );
    return res.data!;
  });

  Future<List<api.Spell>> loadSpells() => _guard(() async {
    final res = await _client.spells.getSpells();
    return res.data?.toList() ?? [];
  });

  api.SetEntrySpellsInputEntryDisciplineEnum? _disciplineEnum(String? slug) =>
      slug == null
      ? null
      : api.standardSerializers.deserializeWith(
          api.SetEntrySpellsInputEntryDisciplineEnum.serializer,
          slug,
        );
}
