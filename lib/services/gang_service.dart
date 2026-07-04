import 'package:carnevale_api/carnevale_api.dart' as api;
import '../models/gang.dart';
import 'api_client.dart';

class GangService {
  static final GangService _instance = GangService._();
  factory GangService() => _instance;
  GangService._();

  final _client = ApiClient();

  Future<List<Gang>> loadAll() async {
    final res = await _client.lists.getLists();
    return (res.data?.toList() ?? []).map(_mapGang).toList();
  }

  Future<Gang> loadOne(int id) async {
    final res = await _client.lists.getList(id: id);
    return _mapGang(res.data!);
  }

  Future<Gang> create(String name, String faction, int points) async {
    final res = await _client.lists.createList(
      listInput: api.ListInput((b) => b
        ..list = api.ListInputList((lb) => lb
          ..name = name
          ..faction = faction
          ..points = points
        ).toBuilder()
      ),
    );
    return _mapGang(res.data!);
  }

  Future<void> delete(int id) async {
    await _client.lists.deleteList(id: id);
  }

  Future<Gang> addEntry(int listId, int entryId, String entryType) async {
    final typeEnum = entryType == 'Equipment'
        ? api.EntryInputEntryEntryTypeEnum.catalogColonColonEquipment
        : api.EntryInputEntryEntryTypeEnum.catalogColonColonCardReference;
    final res = await _client.listEntries.createListEntry(
      entryInput: api.EntryInput((b) => b
        ..entry = api.EntryInputEntry((eb) => eb
          ..listId = listId
          ..entryType = typeEnum
          ..entryId = entryId
        ).toBuilder()
      ),
    );
    return _mapGang(res.data!);
  }

  Future<Gang> removeEntry(int listId, int entryId) async {
    final res = await _client.listEntries.deleteListEntry(id: entryId);
    return _mapGang(res.data!);
  }

  Future<Gang> reorderEntry(int entryId, int position) async {
    final res = await _client.listEntries.updateListEntryPosition(
      id: entryId,
      entryPositionInput: api.EntryPositionInput((b) => b
        ..entry = api.EntryPositionInputEntry((eb) => eb
          ..position = position
        ).toBuilder()
      ),
    );
    return _mapGang(res.data!);
  }

  Gang _mapGang(api.ModelList ml) => Gang(
        id: ml.id,
        name: ml.name ?? '',
        faction: ml.faction,
        points: ml.points,
        totalCost: ml.totalCost,
        selectionValid: ml.selectionValid,
        selectionErrors: ml.selectionErrors.toList(),
        entries: ml.entries.map(_mapEntry).toList(),
      );

  ListEntry _mapEntry(api.ListEntry e) => ListEntry(
        id: e.id,
        position: e.position,
        entryType: e.entryType == api.ListEntryEntryTypeEnum.catalogColonColonEquipment
            ? 'Equipment'
            : 'CardReference',
        entryId: e.entryId,
        name: e.name,
        cost: e.cost,
      );
}
