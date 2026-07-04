# carnevale_api.api.GamesApi

## Load the API package
```dart
import 'package:carnevale_api/api.dart';
```

All URIs are relative to *http://localhost:3000/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**advanceTurn**](GamesApi.md#advanceturn) | **POST** /games/{id}/turns/advance | Advance the game&#39;s shared turn counter
[**archiveGame**](GamesApi.md#archivegame) | **PATCH** /games/{id}/archive | Archive this game for the current user only
[**createGame**](GamesApi.md#creategame) | **POST** /games | Create a game, hosted by the current user
[**deleteGame**](GamesApi.md#deletegame) | **DELETE** /games/{id} | Soft-delete this game for the current user only
[**discardAgenda**](GamesApi.md#discardagenda) | **POST** /games/{id}/agendas/{agenda_id}/discard | Discard an Agenda from this player&#39;s hand
[**drawAgendas**](GamesApi.md#drawagendas) | **POST** /games/{id}/agendas/draw | Privately draw this player&#39;s Agenda cards
[**getAvailableGangs**](GamesApi.md#getavailablegangs) | **GET** /games/{id}/available_lists | The current user&#39;s lists, flagged selectable against this game&#39;s ducat_limit
[**getGame**](GamesApi.md#getgame) | **GET** /games/{id} | Get a game&#39;s full current state
[**getGames**](GamesApi.md#getgames) | **GET** /games | List the current user&#39;s games (to resume/reopen)
[**getPlayerList**](GamesApi.md#getplayerlist) | **GET** /games/{id}/players/{player_id}/list | Either player&#39;s selected gang, in full (with entries)
[**joinGame**](GamesApi.md#joingame) | **POST** /games/join | Join a game via its join_code
[**markReady**](GamesApi.md#markready) | **POST** /games/{id}/ready | Confirm physical deployment is done
[**pickRole**](GamesApi.md#pickrole) | **PATCH** /games/{id}/role | Pick Attacker or Defender (role roll-off winner only)
[**scoreAgenda**](GamesApi.md#scoreagenda) | **POST** /games/{id}/agendas/{agenda_id}/score | Score an Agenda from this player&#39;s hand (flat 1 Victory Point)
[**selectGang**](GamesApi.md#selectgang) | **PATCH** /games/{id}/select_gang | Select a list as the current user&#39;s gang for this game
[**unarchiveGame**](GamesApi.md#unarchivegame) | **PATCH** /games/{id}/unarchive | Restore this game to the current user&#39;s default game list


# **advanceTurn**
> Game advanceTurn(id)

Advance the game's shared turn counter

Callable by either player — like the roll winners and role pick, this app tracks the physical game rather than refereeing whose turn it is to act. On the scenario's final turn, this instead marks the game `completed`. 

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getGamesApi();
final int id = 56; // int | 

try {
    final response = api.advanceTurn(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GamesApi->advanceTurn: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Game**](Game.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **archiveGame**
> Game archiveGame(id)

Archive this game for the current user only

Hides the game from the current user's default game list (`GET /games`), but it remains reachable via `GET /games/{id}`. Purely per-user — the other player's view is unaffected. 

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getGamesApi();
final int id = 56; // int | 

try {
    final response = api.archiveGame(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GamesApi->archiveGame: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Game**](Game.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **createGame**
> Game createGame(createGameInput)

Create a game, hosted by the current user

ducat_limit and name default from the scenario if omitted.

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getGamesApi();
final CreateGameInput createGameInput = ; // CreateGameInput | 

try {
    final response = api.createGame(createGameInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GamesApi->createGame: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createGameInput** | [**CreateGameInput**](CreateGameInput.md)|  | 

### Return type

[**Game**](Game.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteGame**
> deleteGame(id)

Soft-delete this game for the current user only

Hides the game from the current user permanently (they can no longer GET or list it). The other player is unaffected and keeps seeing the game normally. Once every player has deleted the game, it is hard-deleted server-side. 

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getGamesApi();
final int id = 56; // int | 

try {
    api.deleteGame(id);
} on DioException catch (e) {
    print('Exception when calling GamesApi->deleteGame: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **discardAgenda**
> Game discardAgenda(id, agendaId, discardAgendaInput)

Discard an Agenda from this player's hand

Only valid while the game is `in_progress`, and only for an agenda currently in the requesting player's hand. Requires `origin` (`special_rule` or `command_point` — an agenda is never freely discarded, only via one of those). Set `recycle: true` if the scenario's \"Cycle\" rule applies, which immediately draws a replacement card (origin `recycle`, linked back to this discard). 

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getGamesApi();
final int id = 56; // int | 
final int agendaId = 56; // int | 
final DiscardAgendaInput discardAgendaInput = ; // DiscardAgendaInput | 

try {
    final response = api.discardAgenda(id, agendaId, discardAgendaInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GamesApi->discardAgenda: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **agendaId** | **int**|  | 
 **discardAgendaInput** | [**DiscardAgendaInput**](DiscardAgendaInput.md)|  | 

### Return type

[**Game**](Game.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **drawAgendas**
> DrawAgendasResponse drawAgendas(id, drawAgendaInput)

Privately draw this player's Agenda cards

Never broadcast or visible to the opponent. Behavior depends on game status: while `agenda_draw`, draws the scenario's full initial hand (no request body). While `in_progress`, draws a single replacement card and requires `origin` in the body (`special_rule` or `command_point` — a card is never freely drawn mid-game, only granted by one of those). Every agenda a player has ever drawn — whether still in hand, scored, or discarded — can never be drawn again by that same player. 

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getGamesApi();
final int id = 56; // int | 
final DrawAgendaInput drawAgendaInput = ; // DrawAgendaInput | 

try {
    final response = api.drawAgendas(id, drawAgendaInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GamesApi->drawAgendas: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **drawAgendaInput** | [**DrawAgendaInput**](DrawAgendaInput.md)|  | [optional] 

### Return type

[**DrawAgendasResponse**](DrawAgendasResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAvailableGangs**
> BuiltList<AvailableGang> getAvailableGangs(id)

The current user's lists, flagged selectable against this game's ducat_limit

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getGamesApi();
final int id = 56; // int | 

try {
    final response = api.getAvailableGangs(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GamesApi->getAvailableGangs: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**BuiltList&lt;AvailableGang&gt;**](AvailableGang.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getGame**
> Game getGame(id)

Get a game's full current state

Returns 404 if the game doesn't exist or the current user isn't a participant. Agendas are only ever populated for the requesting player's own game_player entry.

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getGamesApi();
final int id = 56; // int | 

try {
    final response = api.getGame(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GamesApi->getGame: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Game**](Game.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getGames**
> BuiltList<Game> getGames(visibility)

List the current user's games (to resume/reopen)

Never includes games the current user has deleted, regardless of the other player's state.

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getGamesApi();
final String visibility = visibility_example; // String | Which of the current user's games to return.

try {
    final response = api.getGames(visibility);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GamesApi->getGames: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **visibility** | **String**| Which of the current user's games to return. | [optional] [default to 'active']

### Return type

[**BuiltList&lt;Game&gt;**](Game.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPlayerList**
> BuiltList getPlayerList(id, playerId)

Either player's selected gang, in full (with entries)

Available for consultation by both participants once that player has picked a gang, regardless of whose turn it currently is — gang lists aren't secret once selected. 

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getGamesApi();
final int id = 56; // int | 
final int playerId = 56; // int | 

try {
    final response = api.getPlayerList(id, playerId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GamesApi->getPlayerList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **playerId** | **int**|  | 

### Return type

[**BuiltList**](BuiltList.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **joinGame**
> Game joinGame(joinGameInput)

Join a game via its join_code

Idempotent if the current user has already joined. Returns 422 if the game is already full. Once the second player joins, the role and deployment roll-off winners are picked at random server-side. The role winner is revealed once that step of the flow is reached; the deployment winner is informational only (the zone itself is chosen at the table, not in-app). 

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getGamesApi();
final JoinGameInput joinGameInput = ; // JoinGameInput | 

try {
    final response = api.joinGame(joinGameInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GamesApi->joinGame: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **joinGameInput** | [**JoinGameInput**](JoinGameInput.md)|  | 

### Return type

[**Game**](Game.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **markReady**
> Game markReady(id)

Confirm physical deployment is done

Once both players are ready, the game's status becomes in_progress and an EntryState (current/starting HP, WP, CP, and status counters) is created for every model (Catalog::CardReference entry) in each player's list.

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getGamesApi();
final int id = 56; // int | 

try {
    final response = api.markReady(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GamesApi->markReady: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Game**](Game.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **pickRole**
> Game pickRole(id, roleInput)

Pick Attacker or Defender (role roll-off winner only)

The roll-off winner is picked at random, server-side, as soon as the second player joins the game — there's no client-triggered roll. `won_role_roll` on the winner's GamePlayer entry is only revealed to clients once this step of the flow is reached. The other player is automatically assigned the remaining role. 

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getGamesApi();
final int id = 56; // int | 
final RoleInput roleInput = ; // RoleInput | 

try {
    final response = api.pickRole(id, roleInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GamesApi->pickRole: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **roleInput** | [**RoleInput**](RoleInput.md)|  | 

### Return type

[**Game**](Game.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **scoreAgenda**
> Game scoreAgenda(id, agendaId, scoreAgendaInput)

Score an Agenda from this player's hand (flat 1 Victory Point)

Only valid while the game is `in_progress`, and only for an agenda currently in the requesting player's hand. Set `recycle: true` if the scenario's \"Cycle\" rule applies, which immediately draws a replacement card (origin `recycle`, linked back to this score). 

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getGamesApi();
final int id = 56; // int | 
final int agendaId = 56; // int | 
final ScoreAgendaInput scoreAgendaInput = ; // ScoreAgendaInput | 

try {
    final response = api.scoreAgenda(id, agendaId, scoreAgendaInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GamesApi->scoreAgenda: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **agendaId** | **int**|  | 
 **scoreAgendaInput** | [**ScoreAgendaInput**](ScoreAgendaInput.md)|  | [optional] 

### Return type

[**Game**](Game.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **selectGang**
> Game selectGang(id, selectGangInput)

Select a list as the current user's gang for this game

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getGamesApi();
final int id = 56; // int | 
final SelectGangInput selectGangInput = ; // SelectGangInput | 

try {
    final response = api.selectGang(id, selectGangInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GamesApi->selectGang: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **selectGangInput** | [**SelectGangInput**](SelectGangInput.md)|  | 

### Return type

[**Game**](Game.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **unarchiveGame**
> Game unarchiveGame(id)

Restore this game to the current user's default game list

Reverses `archive` for the current user only.

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getGamesApi();
final int id = 56; // int | 

try {
    final response = api.unarchiveGame(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GamesApi->unarchiveGame: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Game**](Game.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

