import 'package:test/test.dart';
import 'package:carnevale_api/carnevale_api.dart';


/// tests for GamesApi
void main() {
  final instance = CarnevaleApi().getGamesApi();

  group(GamesApi, () {
    // Create a game, hosted by the current user
    //
    // ducat_limit defaults from the scenario if omitted.
    //
    //Future<Game> createGame(CreateGameInput createGameInput) async
    test('test createGame', () async {
      // TODO
    });

    // Privately draw this player's Agenda cards
    //
    // Never broadcast or visible to the opponent.
    //
    //Future<DrawAgendasResponse> drawAgendas(int id) async
    test('test drawAgendas', () async {
      // TODO
    });

    // The current user's lists, flagged selectable against this game's ducat_limit
    //
    //Future<BuiltList<AvailableGang>> getAvailableGangs(int id) async
    test('test getAvailableGangs', () async {
      // TODO
    });

    // Get a game's full current state
    //
    // Returns 404 if the game doesn't exist or the current user isn't a participant. Agendas are only ever populated for the requesting player's own game_player entry.
    //
    //Future<Game> getGame(int id) async
    test('test getGame', () async {
      // TODO
    });

    // List the current user's games (to resume/reopen)
    //
    //Future<BuiltList<Game>> getGames() async
    test('test getGames', () async {
      // TODO
    });

    // Join a game via its join_code
    //
    // Idempotent if the current user has already joined. Returns 422 if the game is already full.
    //
    //Future<Game> joinGame(JoinGameInput joinGameInput) async
    test('test joinGame', () async {
      // TODO
    });

    // Confirm physical deployment is done
    //
    // Once both players are ready, the game's status becomes in_progress.
    //
    //Future<Game> markReady(int id) async
    test('test markReady', () async {
      // TODO
    });

    // Pick a Deployment Zone (deployment roll-off winner only)
    //
    // The other player is automatically assigned the remaining zone.
    //
    //Future<Game> pickDeploymentZone(int id, DeploymentZoneInput deploymentZoneInput) async
    test('test pickDeploymentZone', () async {
      // TODO
    });

    // Pick Attacker or Defender (role roll-off winner only)
    //
    // The other player is automatically assigned the remaining role.
    //
    //Future<Game> pickRole(int id, RoleInput roleInput) async
    test('test pickRole', () async {
      // TODO
    });

    // Roll the deployment-priority die
    //
    // Ties are re-rolled automatically, server-side, before this responds.
    //
    //Future<Game> rollForDeployment(int id) async
    test('test rollForDeployment', () async {
      // TODO
    });

    // Roll for Attacker/Defender priority (asymmetric scenarios only)
    //
    // Ties are re-rolled automatically, server-side, before this responds.
    //
    //Future<Game> rollForRole(int id) async
    test('test rollForRole', () async {
      // TODO
    });

    // Select a list as the current user's gang for this game
    //
    //Future<Game> selectGang(int id, SelectGangInput selectGangInput) async
    test('test selectGang', () async {
      // TODO
    });

  });
}
