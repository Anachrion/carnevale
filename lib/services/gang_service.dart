import 'package:built_collection/built_collection.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:dio/dio.dart';
import '../models/gang.dart';
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

  Future<List<Gang>> loadAll() => _guard(() async {
    final res = await _client.lists.getLists();
    return (res.data?.toList() ?? []).map(mapGang).toList();
  });

  Future<Gang> loadOne(int id) => _guard(() async {
    final res = await _client.lists.getList(id: id);
    return mapGang(res.data!);
  });

  Future<Gang> create(String name, String faction, int points) =>
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
        return mapGang(res.data!);
      });

  Future<void> delete(int id) => _guard(() async {
    await _client.lists.deleteList(id: id);
  });

  Future<Gang> addEntry(int listId, int entryId, String entryType) =>
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
        return mapGang(res.data!);
      });

  Future<Gang> removeEntry(int entryId) => _guard(() async {
    final res = await _client.listEntries.deleteListEntry(id: entryId);
    return mapGang(res.data!);
  });

  Future<Gang> reorderEntry(int entryId, int position) => _guard(() async {
    final res = await _client.listEntries.updateListEntryPosition(
      id: entryId,
      entryPositionInput: api.EntryPositionInput(
        (b) => b
          ..entry = api.EntryPositionInputEntry(
            (eb) => eb..position = position,
          ).toBuilder(),
      ),
    );
    return mapGang(res.data!);
  });

  /// Replaces a Mage model's committed Discipline and full set of known spells (rulebook p24).
  Future<Gang> setEntrySpells(
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
    return mapGang(res.data!);
  });

  Future<List<Spell>> loadSpells() => _guard(() async {
    final res = await _client.spells.getSpells();
    return (res.data?.toList() ?? []).map(mapSpell).toList();
  });

  Gang mapGang(api.ModelList ml) => Gang(
    id: ml.id,
    name: ml.name ?? '',
    faction: ml.faction,
    points: ml.points,
    totalCost: ml.totalCost,
    selectionValid: ml.selectionValid,
    selectionErrors: ml.selectionErrors.toList(),
    entries: ml.entries.map(mapEntry).toList(),
  );

  ListEntry mapEntry(api.ListEntry e) => ListEntry(
    id: e.id,
    position: e.position,
    entryType:
        e.entryType == api.ListEntryEntryTypeEnum.catalogColonColonEquipment
        ? 'Equipment'
        : 'CardReference',
    entryId: e.entryId,
    name: e.name,
    cost: e.cost,
    state: e.state,
    mage: e.mage,
    spellSlots: e.spellSlots,
    disciplines: e.disciplines.toList(),
    spellDiscipline: e.spellDiscipline,
    cantrip: e.cantrip == null ? null : mapSpell(e.cantrip!),
    spells: e.spells.map(mapSpell).toList(),
  );

  Spell mapSpell(api.Spell s) => Spell(
    id: s.id,
    name: s.name,
    discipline:
        api.standardSerializers.serializeWith(
              api.SpellDisciplineEnum.serializer,
              s.discipline,
            )
            as String,
    cost: s.cost,
    difficulty: s.difficulty,
    cantrip: s.cantrip,
    description: s.description,
  );

  api.SetEntrySpellsInputEntryDisciplineEnum? _disciplineEnum(String? slug) =>
      slug == null
      ? null
      : api.standardSerializers.deserializeWith(
          api.SetEntrySpellsInputEntryDisciplineEnum.serializer,
          slug,
        );
}
