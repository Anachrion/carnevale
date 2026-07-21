// Copyright 2026 Anachrion
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:built_collection/built_collection.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:dio/dio.dart';
import '../models/spell_selection.dart';
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

  // The last-loaded gangs for this session, so the index can show them instantly on every visit
  // instead of refetching each time. Unlike the catalog caches this is per-user, so it's cleared on
  // logout (AuthService#_clear). Kept coherent with local edits via [cacheGangs].
  List<api.ModelList>? _gangsCache;

  /// The cached gangs, or null if none loaded yet this session (defensive copy).
  List<api.ModelList>? get cachedGangs =>
      _gangsCache == null ? null : List.of(_gangsCache!);

  Future<List<api.ModelList>> loadAll() => _guard(() async {
    final res = await _client.lists.getLists();
    _gangsCache = res.data?.toList() ?? [];
    return List.of(_gangsCache!);
  });

  /// Updates the cached index to match an edit the screen already applied locally (a gang edited in
  /// the builder, or a create/delete), so navigating away and back reflects it without a refetch.
  void cacheGangs(List<api.ModelList> gangs) => _gangsCache = List.of(gangs);

  /// Clears the cached gangs — the index is per-user, so this runs on logout / session end.
  void resetGangsCache() => _gangsCache = null;

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

  /// Replaces a Mage model's spell selection, one pool at a time (rulebook p24) — every one of the
  /// entry's pools must be included in [poolSelections] (an omitted pool loses its picks). Only
  /// pass [mentorChanged]/[mentoredByEntryId] for a model with a mentor_derived pool (Apprentice
  /// Doctor's Apprenticeship); omitting the field server-side leaves the current mentor untouched.
  Future<api.ModelList> setEntrySpells(
    int entryId, {
    required List<PoolSelectionResult> poolSelections,
    bool mentorChanged = false,
    int? mentoredByEntryId,
  }) => _guard(() async {
    final res = await _client.listEntries.setListEntrySpells(
      id: entryId,
      setEntrySpellsInput: api.SetEntrySpellsInput(
        (b) => b
          ..entry = api.SetEntrySpellsInputEntry(
            (eb) {
              if (mentorChanged) eb.mentoredByEntryId = mentoredByEntryId;
              eb.poolSelections = ListBuilder<api.SetEntrySpellsInputEntryPoolSelectionsInner>(
                poolSelections.map(
                  (p) => api.SetEntrySpellsInputEntryPoolSelectionsInner(
                    (pb) => pb
                      ..poolId = p.poolId
                      ..disciplines = ListBuilder<api.SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum>(
                        p.disciplines.map(_poolSelectionDisciplineEnum),
                      )
                      ..spellIds = ListBuilder<int>(p.spellIds),
                  ),
                ),
              );
            },
          ).toBuilder(),
      ),
    );
    return res.data!;
  });

  /// Repoints an entry at a different card reference of the same profile — swaps which illustration
  /// the model is hired as, without changing who it is. `cardReferenceId` must be a sibling card
  /// reference of the entry's current profile; the backend rejects anything else.
  Future<api.ModelList> setEntryIllustration(int entryId, int cardReferenceId) =>
      _guard(() async {
        final res = await _client.listEntries.setListEntryIllustration(
          id: entryId,
          entryIllustrationInput: api.EntryIllustrationInput(
            (b) => b
              ..entry = api.EntryIllustrationInputEntry(
                (eb) => eb..entryId = cardReferenceId,
              ).toBuilder(),
          ),
        );
        return res.data!;
      });

  /// Buys or drops a model's optional paid upgrade — the Emissary of Mother Hydra's +12 Ducats for a
  /// second set of Tentacles (CARNEVALEB-23). The backend reconciles the model's auto-included
  /// companion entries to match and returns the whole updated list, so the caller just swaps it in.
  Future<api.ModelList> setEntryUpgrade(int entryId, bool selected) =>
      _guard(() async {
        final res = await _client.listEntries.setListEntryUpgrade(
          id: entryId,
          entryUpgradeInput: api.EntryUpgradeInput(
            (b) => b
              ..entry = api.EntryUpgradeInputEntry(
                (eb) => eb..upgradeSelected = selected,
              ).toBuilder(),
          ),
        );
        return res.data!;
      });

  api.SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum
  _poolSelectionDisciplineEnum(String slug) =>
      api.standardSerializers.deserializeWith(
        api.SetEntrySpellsInputEntryPoolSelectionsInnerDisciplinesEnum.serializer,
        slug,
      )!;
}
