import 'dart:convert';
import 'dart:typed_data';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:carnevale/services/api_client.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A Dio adapter that returns canned JSON per `METHOD /path`, so widget/service tests can drive the
/// real service -> generated-client -> model-mapping stack without a backend. Installed on the
/// shared ApiClient's Dio via [installFakeApi].
class FakeApiAdapter implements HttpClientAdapter {
  final Map<String, Object?> _routes = {};

  /// Registers a response body (a JSON-encodable Map/List) for a request. Build [body] with the
  /// generated serializers (see the fixtures below) so it matches the client's expected schema.
  void stub(String method, String path, Object? body) {
    _routes['$method $path'] = body;
  }

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final key = '${options.method} ${options.path}';
    final has = _routes.containsKey(key);
    final body = has
        ? _routes[key]
        : {
            'errors': {
              'base': ['not stubbed: $key'],
            },
          };
    return ResponseBody.fromString(
      json.encode(body),
      has ? 200 : 404,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

/// Installs a fresh [FakeApiAdapter] on the shared ApiClient and returns it for stubbing.
///
/// Also seeds an in-memory SharedPreferences: the catalog services now persist their last-good
/// data through it (offline cache, C-6), and without a mock `getInstance()` never completes in a
/// widget test, hanging the load. An empty store is the right blank-slate default per test.
FakeApiAdapter installFakeApi() {
  SharedPreferences.setMockInitialValues({});
  final adapter = FakeApiAdapter();
  ApiClient().dio.httpClientAdapter = adapter;
  return adapter;
}

/// Serializes generated built_value objects to the primitive Map/List the adapter re-encodes,
/// guaranteeing the canned body matches the client's deserializer.
Object _serialize(Object value, FullType type) =>
    api.standardSerializers.serialize(value, specifiedType: type)!;

Object listBody<T>(Iterable<T> items, FullType itemType) =>
    _serialize(BuiltList<T>(items), FullType(BuiltList, [itemType]));

Object gameBody(api.Game game) => _serialize(game, const FullType(api.Game));

Object modelListBody(api.ModelList list) =>
    _serialize(list, const FullType(api.ModelList));

Object entryStateBody(api.EntryState state) =>
    _serialize(state, const FullType(api.EntryState));

api.Equipment fakeEquipment({
  int id = 1,
  String name = 'Gondola',
  String description = 'A boat.',
  int cost = 10,
}) => api.Equipment(
  (b) => b
    ..id = id
    ..name = name
    ..description = description
    ..cost = cost,
);

api.ListEntry fakeListEntry({
  int id = 1,
  int position = 1,
  api.ListEntryEntryTypeEnum entryType =
      api.ListEntryEntryTypeEnum.catalogColonColonCardReference,
  int entryId = 10,
  String name = 'Capodecina',
  int cost = 20,
  List<String> keywords = const [],
  bool flexibleLeader = false,
  bool demotedLeader = false,
  bool promotableLeader = false,
  api.EntryState? state,
  bool summoned = false,
  int? companionOfEntryId,
  bool upgradeSelected = false,
  bool upgradeAvailable = false,
  int upgradeDucats = 0,
}) => api.ListEntry(
  (b) => b
    ..id = id
    ..position = position
    ..entryType = entryType
    ..entryId = entryId
    ..name = name
    ..keywords = ListBuilder<String>(keywords)
    ..flexibleLeader = flexibleLeader
    ..demotedLeader = demotedLeader
    ..promotableLeader = promotableLeader
    ..cost = cost
    ..summoned = summoned
    // An ordinary hired model: brought in by nobody, and offering no paid upgrade (CARNEVALEB-23).
    // Pass these to build an Emissary of Mother Hydra or one of its Tentacles.
    ..companionOfEntryId = companionOfEntryId
    ..upgradeSelected = upgradeSelected
    ..upgradeAvailable = upgradeAvailable
    ..upgradeDucats = upgradeDucats
    ..mage = false
    ..distinctDisciplinePerCopy = false
    ..pools = ListBuilder<api.SpellPool>()
    ..grantedSpells = ListBuilder<api.GrantedSpell>()
    // Only models in a live game have a state; a gang-builder entry leaves it null.
    ..state = state?.toBuilder(),
);

api.EntryStatValue _fakeStat(int current, int starting) => api.EntryStatValue(
  (b) => b
    ..current = current
    ..starting = starting,
);

api.EntryState fakeEntryState({
  int lifePoints = 10,
  int willPoints = 3,
  int commandPoints = 1,
  bool stunned = false,
  bool hidden = false,
  bool guarding = false,
  bool carryingObjective = false,
  int underwaterCounters = 0,
  bool activated = false,
}) => api.EntryState(
  (b) => b
    ..lifePoints = _fakeStat(lifePoints, 10).toBuilder()
    ..willPoints = _fakeStat(willPoints, 3).toBuilder()
    ..commandPoints = _fakeStat(commandPoints, 1).toBuilder()
    ..stunned = stunned
    ..hidden = hidden
    ..guarding = guarding
    ..carryingObjective = carryingObjective
    ..underwaterCounters = underwaterCounters
    ..activated = activated
    // Derived server-side from HP, so the fixture derives it the same way rather than letting a
    // test set up a model that is dead at full health (or alive at 0) — a state the API can't produce.
    ..dead = lifePoints == 0,
);

api.Spell fakeSpell({
  int id = 1,
  String name = 'Blood Boil',
  api.SpellDisciplineEnum discipline = api.SpellDisciplineEnum.bloodRites,
  bool cantrip = false,
}) => api.Spell(
  (b) => b
    ..id = id
    ..name = name
    ..discipline = discipline
    ..cost = 2
    ..difficulty = 3
    ..cantrip = cantrip
    ..description = 'Boils the blood.',
);

api.ModelList fakeModelList({
  int id = 1,
  String name = 'The Rooks',
  String faction = 'guild',
  int points = 200,
  int totalCost = 20,
  List<api.ListEntry> entries = const [],
}) => api.ModelList(
  (b) => b
    ..id = id
    ..name = name
    ..faction = faction
    ..points = points
    ..totalCost = totalCost
    ..selectionValid = true
    ..selectionErrors = ListBuilder<String>()
    ..entries = ListBuilder<api.ListEntry>(
      entries.isEmpty ? [fakeListEntry()] : entries,
    ),
);

// ── Fixtures ────────────────────────────────────────────────────────────────

api.Profile fakeProfile({
  int id = 1,
  String name = 'Capodecina',
  String faction = 'guild',
  int ducats = 20,
  List<String> keywords = const ['Leader'],
  bool flexibleLeader = false,
  int? flexibleLeaderWith,
  bool recruitable = true,
  List<String> abilities = const [],
  List<api.Weapon> weapons = const [],
  List<api.SpecialRule> specialRules = const [],
  List<api.CardReference> cardReferences = const [],
}) => api.Profile(
  (b) => b
    ..id = id
    ..name = name
    ..faction = faction
    ..flexibleLeader = flexibleLeader
    ..flexibleLeaderWith = flexibleLeaderWith
    // Every ordinary model can be hired or summoned; pass false for a companion-only model such as
    // the Emissary of Mother Hydra's Tentacles, which the hire/summon pickers must hide.
    ..recruitable = recruitable
    ..ducats = ducats
    ..movement = 4
    ..attack = 3
    ..dexterity = 3
    ..lifePoints = 2
    ..mind = 3
    ..willPoints = 2
    ..protection = 5
    ..actionPoints = 2
    ..commandPoints = 1
    ..size = 2
    ..version = 'v1'
    ..mage = false
    ..spellSlots = 0
    ..abilities = ListBuilder<String>(abilities)
    ..keywords = ListBuilder<String>(keywords)
    ..disciplines = ListBuilder<String>()
    ..weapons = ListBuilder<api.Weapon>(weapons)
    ..specialRules = ListBuilder<api.SpecialRule>(specialRules)
    ..cardReferences = ListBuilder<api.CardReference>(
      cardReferences.isEmpty
          ? [fakeCardReference(profileName: name)]
          : cardReferences,
    ),
);

api.Weapon fakeWeapon({
  int id = 1,
  String name = 'Stiletto',
  List<String> abilities = const [],
}) => api.Weapon(
  (b) => b
    ..id = id
    ..name = name
    ..damage = 3
    ..range = 0
    ..penetration = 1
    ..evasion = 0
    ..abilities = ListBuilder<String>(abilities),
);

api.SpecialRule fakeSpecialRule({
  int id = 1,
  String name = 'Blood Frenzy',
  String description = 'Attacks twice when wounded.',
  String? spellName,
  String? spellDescription,
}) => api.SpecialRule(
  (b) => b
    ..id = id
    ..name = name
    ..description = description
    ..spellName = spellName
    ..spellCost = spellName == null ? null : 2
    ..spellDifficulty = spellName == null ? null : 3
    ..spellDescription = spellDescription,
);

api.Scenario fakeScenario({
  int id = 1,
  String name = 'Gang War',
  List<api.ScenarioAgendaRulesEnum> agendaRules = const [],
  int agendaCount = 3,
}) => api.Scenario(
  (b) => b
    ..id = id
    ..name = name
    ..ducats = 150
    ..asymmetric = false
    ..setup = 'Setup text.'
    ..primaryObjective = 'Objective text.'
    ..agendas = ListBuilder<String>(['3 agendas.'])
    ..agendaRules = ListBuilder<api.ScenarioAgendaRulesEnum>(agendaRules)
    ..agendaCount = agendaCount
    ..specialRules = ListBuilder<String>()
    ..duration = '5 rounds.'
    ..turns = 5
    ..deploymentZones = ListBuilder<String>(['Opposite edges.']),
);

api.Agenda fakeAgenda({
  int id = 1,
  String name = 'No Mercy',
  String description = 'Cause at least 8 points of Damage in a single turn.',
}) => api.Agenda(
  (b) => b
    ..id = id
    ..name = name
    ..description = description,
);

api.AgendaHistoryEntry fakeAgendaHistoryEntry({
  int turn = 1,
  api.AgendaHistoryEntryActionEnum action =
      api.AgendaHistoryEntryActionEnum.scored,
  api.AgendaHistoryEntryOriginEnum? origin,
  int agendaId = 1,
  String agendaName = 'No Mercy',
}) => api.AgendaHistoryEntry(
  (b) => b
    ..turn = turn
    ..action = action
    ..origin = origin
    ..causedByEventId = null
    ..agenda.replace(
      api.AgendaHistoryEntryAgenda(
        (ab) => ab
          ..id = agendaId
          ..name = agendaName,
      ),
    ),
);

api.GamePlayer fakeGamePlayer({
  int id = 1,
  int userId = 1,
  String username = 'tester',
  bool host = true,
  bool agendasConfirmed = false,
  int score = 0,
  int currentTurn = 1,
  bool finished = false,
  List<api.Agenda> agendas = const [],
  List<api.AgendaHistoryEntry> agendaHistory = const [],
}) => api.GamePlayer(
  (b) => b
    ..id = id
    ..userId = userId
    ..username = username
    ..host = host
    ..agendasConfirmed = agendasConfirmed
    ..wonRoleRoll = false
    ..wonDeploymentRoll = false
    ..score = score
    ..currentTurn = currentTurn
    ..finished = finished
    ..agendas = ListBuilder<api.Agenda>(agendas)
    ..agendaHistory = ListBuilder<api.AgendaHistoryEntry>(agendaHistory),
);

api.Game fakeGame({
  int id = 1,
  String name = 'Gang War',
  String joinCode = 'ABC123',
  api.GameStatusEnum status = api.GameStatusEnum.pending,
  api.Scenario? scenario,
  List<api.GamePlayer> players = const [],
}) => api.Game(
  (b) => b
    ..id = id
    ..name = name
    ..joinCode = joinCode
    ..status = status
    ..ducatLimit = 150
    ..viewerVisibility = api.GameViewerVisibilityEnum.active
    ..scenario = (scenario ?? fakeScenario()).toBuilder()
    ..players = ListBuilder<api.GamePlayer>(
      players.isEmpty ? [fakeGamePlayer()] : players,
    ),
);

api.CardReference fakeCardReference({
  int id = 10,
  String identifier = 'guild-capodecina',
  String profileName = 'Capodecina',
  String cardFront = 'front.png',
  String cardBack = 'back.png',
}) => api.CardReference(
  (b) => b
    ..id = id
    ..identifier = identifier
    ..name = profileName
    ..cardFront = cardFront
    ..cardBack = cardBack,
);
