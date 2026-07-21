# carnevale_api.api.GamesApi

## Load the API package
```dart
import 'package:carnevale_api/api.dart';
```

All URIs are relative to *http://localhost:3000/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**advanceTurn**](GamesApi.md#advanceturn) | **POST** /games/{id}/turns/advance | Advance the requesting player&#39;s turn cursor
[**archiveGame**](GamesApi.md#archivegame) | **PATCH** /games/{id}/archive | Archive this game for the current user only
[**confirmAgendas**](GamesApi.md#confirmagendas) | **POST** /games/{id}/agendas/confirm | Confirm this player&#39;s opening Agenda hand
[**createGame**](GamesApi.md#creategame) | **POST** /games | Create a game, hosted by the current user
[**deleteGame**](GamesApi.md#deletegame) | **DELETE** /games/{id} | Soft-delete this game for the current user only
[**deselectGang**](GamesApi.md#deselectgang) | **DELETE** /games/{id}/select_gang | Clear the current user&#39;s gang selection for this game (still in gang selection)
[**discardAgenda**](GamesApi.md#discardagenda) | **POST** /games/{id}/agendas/{agenda_id}/discard | Discard an Agenda from this player&#39;s hand
[**dismissSummon**](GamesApi.md#dismisssummon) | **DELETE** /games/{id}/summons/{list_entry_id} | Remove a summoned model from the current player&#39;s gang
[**drawAgendas**](GamesApi.md#drawagendas) | **POST** /games/{id}/agendas/draw | Draw a single in-play Agenda card
[**finishGame**](GamesApi.md#finishgame) | **POST** /games/{id}/finish | End the game from the requesting player&#39;s side
[**getAvailableGangs**](GamesApi.md#getavailablegangs) | **GET** /games/{id}/available_lists | The current user&#39;s lists, flagged selectable against this game&#39;s ducat_limit
[**getGame**](GamesApi.md#getgame) | **GET** /games/{id} | Get a game&#39;s full current state
[**getGames**](GamesApi.md#getgames) | **GET** /games | List the current user&#39;s games (to resume/reopen)
[**getPlayerList**](GamesApi.md#getplayerlist) | **GET** /games/{id}/players/{player_id}/list | Either player&#39;s selected gang, in full (with entries)
[**joinGame**](GamesApi.md#joingame) | **POST** /games/join | Join a game via its join_code
[**pickRole**](GamesApi.md#pickrole) | **PATCH** /games/{id}/role | Pick Attacker or Defender (role roll-off winner only)
[**removeToken**](GamesApi.md#removetoken) | **DELETE** /games/{id}/entries/{list_entry_id}/tokens/{token_id} | Remove a player token from one of the current player&#39;s own models
[**rewindTurn**](GamesApi.md#rewindturn) | **POST** /games/{id}/turns/rewind | Rewind the requesting player&#39;s turn cursor
[**scoreAgenda**](GamesApi.md#scoreagenda) | **POST** /games/{id}/agendas/{agenda_id}/score | Score an Agenda from this player&#39;s hand (flat 1 Victory Point)
[**selectGang**](GamesApi.md#selectgang) | **PATCH** /games/{id}/select_gang | Select a list as the current user&#39;s gang for this game
[**summonModel**](GamesApi.md#summonmodel) | **POST** /games/{id}/summons | Conjure a model onto the board and add it to the current player&#39;s gang
[**unarchiveGame**](GamesApi.md#unarchivegame) | **PATCH** /games/{id}/unarchive | Restore this game to the current user&#39;s default game list
[**unfinishGame**](GamesApi.md#unfinishgame) | **POST** /games/{id}/unfinish | Undo ending the game for the requesting player
[**updateCounters**](GamesApi.md#updatecounters) | **PATCH** /games/{id}/entries/{list_entry_id}/counters | Update status counters on one of the current player&#39;s own models
[**updateSpellCast**](GamesApi.md#updatespellcast) | **PATCH** /games/{id}/entries/{list_entry_id}/spell_casts | Mark (or unmark) one known/granted spell as cast, on one of the current player&#39;s own models
[**updateStats**](GamesApi.md#updatestats) | **PATCH** /games/{id}/entries/{list_entry_id}/stats | Update current HP/WP/CP on one of the current player&#39;s own models
[**updateToken**](GamesApi.md#updatetoken) | **PATCH** /games/{id}/entries/{list_entry_id}/tokens | Add or update a player token on one of the current player&#39;s own models


# **advanceTurn**
> Game advanceTurn(id)

Advance the requesting player's turn cursor

Moves only the requesting player's own turn cursor forward by one (never the opponent's), clamped to the scenario's turn count. The cursor is per-player and rewindable so a player can drop back to record a forgotten past-turn score, then step forward again. Blocked while the game isn't `in_progress` or the player has ended the game (see `finish`). 

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

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

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

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
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

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

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **confirmAgendas**
> Game confirmAgendas(id)

Confirm this player's opening Agenda hand

Marks the player done with the `agenda_draw` phase after they've reviewed and optionally mulliganed their auto-dealt opening hand. Once both players confirm, the game goes straight to `in_progress` — deployment zones are agreed at the table, so there is no separate in-app deployment step — and an EntryState (current/starting HP, WP, CP, and status counters) is created for every model (Catalog::CardReference entry) in each list. 

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

final api = CarnevaleApi().getGamesApi();
final int id = 56; // int | 

try {
    final response = api.confirmAgendas(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GamesApi->confirmAgendas: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Game**](Game.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

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
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

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

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

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
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

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

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deselectGang**
> Game deselectGang(id)

Clear the current user's gang selection for this game (still in gang selection)

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

final api = CarnevaleApi().getGamesApi();
final int id = 56; // int | 

try {
    final response = api.deselectGang(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GamesApi->deselectGang: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Game**](Game.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **discardAgenda**
> Game discardAgenda(id, agendaId, discardAgendaInput)

Discard an Agenda from this player's hand

Discards an agenda currently in the requesting player's hand. Valid `origin` values:   * `unachievable` — tossing an impossible or duplicated agenda and swapping it for a fresh     one. Always draws a replacement (origin `recycle`). Allowed both during setup     (`agenda_draw`, the pre-game mulligan) and mid-game (`in_progress`); or   * `special_rule` / `command_point` — an in-play discard (only while `in_progress`) granted     by one of those, which draws a replacement only when `recycle: true`. A discarded agenda is always visible to the opponent (even under the Secret rule). 

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

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

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **dismissSummon**
> BuiltList dismissSummon(id, listEntryId)

Remove a summoned model from the current player's gang

Undoes a summon — a mis-tap, or a rule that no longer sustains the model. Only summoned models can be removed: the hired roster is frozen the moment the game starts, so a player cannot quietly delete a model they are losing with. Attempting it on a hired model is a 422. Broadcast to both players; the response is the player's updated gang. 

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

final api = CarnevaleApi().getGamesApi();
final int id = 56; // int | 
final int listEntryId = 56; // int | 

try {
    final response = api.dismissSummon(id, listEntryId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GamesApi->dismissSummon: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **listEntryId** | **int**|  | 

### Return type

[**BuiltList**](BuiltList.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **drawAgendas**
> DrawAgendasResponse drawAgendas(id, drawAgendaInput)

Draw a single in-play Agenda card

Only valid while the game is `in_progress`. Draws one replacement card and requires `origin` in the body (`special_rule` or `command_point` — a card is never freely drawn mid-game, only granted by one of those). The opening hand is **not** drawn here: it is dealt automatically the moment the game enters `agenda_draw` (both players' hands at once), so there is no initial-draw call — clients read the pre-dealt hand from the player's `agendas` and go straight to reviewing/mulliganing and `agendas/confirm`. Every agenda a player has ever drawn — whether still in hand, scored, or discarded — can never be drawn again by that same player. 

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

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
 **drawAgendaInput** | [**DrawAgendaInput**](DrawAgendaInput.md)|  | 

### Return type

[**DrawAgendasResponse**](DrawAgendasResponse.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **finishGame**
> Game finishGame(id)

End the game from the requesting player's side

Marks the requesting player as finished and archives the game for them (moving it to their archived list); the opponent is untouched and keeps playing at their own pace. Only allowed on the scenario's final turn. Once both players finish, the game's `status` derives to `completed`. Reversible via `unfinish`. 

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

final api = CarnevaleApi().getGamesApi();
final int id = 56; // int | 

try {
    final response = api.finishGame(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GamesApi->finishGame: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Game**](Game.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getAvailableGangs**
> BuiltList<AvailableGang> getAvailableGangs(id)

The current user's lists, flagged selectable against this game's ducat_limit

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

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

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getGame**
> Game getGame(id)

Get a game's full current state

Returns 404 if the game doesn't exist or the current user isn't a participant. The opponent's agendas are populated too, except under the scenario's `secret` agenda rule, where the opponent's hand is hidden (see the GamePlayer.agendas description).

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

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

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

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
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

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

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

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
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

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

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

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
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

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

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **pickRole**
> Game pickRole(id, roleInput)

Pick Attacker or Defender (role roll-off winner only)

The roll-off winner is picked at random, server-side, as soon as the second player joins the game — there's no client-triggered roll. `won_role_roll` on the winner's GamePlayer entry is only revealed to clients once this step of the flow is reached. The other player is automatically assigned the remaining role. 

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

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

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **removeToken**
> EntryState removeToken(id, listEntryId, tokenId)

Remove a player token from one of the current player's own models

Removes the token with this client-generated id. Only available while the game is in_progress, and only for the requesting player's own models. Broadcast to both players. 

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

final api = CarnevaleApi().getGamesApi();
final int id = 56; // int | 
final int listEntryId = 56; // int | 
final String tokenId = tokenId_example; // String | 

try {
    final response = api.removeToken(id, listEntryId, tokenId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GamesApi->removeToken: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **listEntryId** | **int**|  | 
 **tokenId** | **String**|  | 

### Return type

[**EntryState**](EntryState.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **rewindTurn**
> Game rewindTurn(id)

Rewind the requesting player's turn cursor

Moves only the requesting player's own turn cursor back by one, clamped to turn 1. Used to drop back and record a forgotten past-turn score before advancing forward again. Blocked while the game isn't `in_progress` or the player has ended the game. 

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

final api = CarnevaleApi().getGamesApi();
final int id = 56; // int | 

try {
    final response = api.rewindTurn(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GamesApi->rewindTurn: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Game**](Game.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **scoreAgenda**
> Game scoreAgenda(id, agendaId)

Score an Agenda from this player's hand (flat 1 Victory Point)

Only valid while the game is `in_progress`, and only for an agenda currently in the requesting player's hand. Takes no body. If the scenario carries the \"Cycle\" rule, scoring automatically draws a replacement card (origin `recycle`, linked back to this score) — this is driven by the scenario, not requested by the client. 

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

final api = CarnevaleApi().getGamesApi();
final int id = 56; // int | 
final int agendaId = 56; // int | 

try {
    final response = api.scoreAgenda(id, agendaId);
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

### Return type

[**Game**](Game.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **selectGang**
> Game selectGang(id, selectGangInput)

Select a list as the current user's gang for this game

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

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

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **summonModel**
> BuiltList summonModel(id, summonModelRequest, idempotencyKey)

Conjure a model onto the board and add it to the current player's gang

For the rare models whose special rules summon or raise new models mid-battle. Only available while the game is in_progress.  Any model in the catalog may be summoned — the rule lives on the summoner's card, so the app tracks the summon rather than adjudicating it, and a summon from outside the gang's own faction is expected rather than exceptional.  The new model joins the player's (otherwise frozen) gang with an entry state of its own, so it takes damage, carries counters and activates like any hired model. It is flagged `summoned`, which exempts it from the gang-building rules: it costs the gang no ducats and cannot push it over its limit or flip it to invalid. Broadcast to both players as a `game_state` event; the response is the player's updated gang. 

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

final api = CarnevaleApi().getGamesApi();
final int id = 56; // int | 
final SummonModelRequest summonModelRequest = ; // SummonModelRequest | 
final String idempotencyKey = idempotencyKey_example; // String | Optional client-generated opaque token that makes this additive create idempotent: a request re-sent after a lost response (e.g. the app's optimistic sync queue retrying a timed-out hire) replays the original result instead of creating a duplicate. Mint one token per logical action and reuse it across that action's retries. Bounded to `[A-Za-z0-9._-]{16,128}`; a value outside that is ignored (the create proceeds non-idempotently). 

try {
    final response = api.summonModel(id, summonModelRequest, idempotencyKey);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GamesApi->summonModel: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **summonModelRequest** | [**SummonModelRequest**](SummonModelRequest.md)|  | 
 **idempotencyKey** | **String**| Optional client-generated opaque token that makes this additive create idempotent: a request re-sent after a lost response (e.g. the app's optimistic sync queue retrying a timed-out hire) replays the original result instead of creating a duplicate. Mint one token per logical action and reuse it across that action's retries. Bounded to `[A-Za-z0-9._-]{16,128}`; a value outside that is ignored (the create proceeds non-idempotently).  | [optional] 

### Return type

[**BuiltList**](BuiltList.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

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
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

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

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **unfinishGame**
> Game unfinishGame(id)

Undo ending the game for the requesting player

Clears the requesting player's finished flag and un-archives the game (returning it to their active list), reopening play. If the game had derived to `completed`, it reverts to `in_progress`. 

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

final api = CarnevaleApi().getGamesApi();
final int id = 56; // int | 

try {
    final response = api.unfinishGame(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GamesApi->unfinishGame: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Game**](Game.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateCounters**
> EntryState updateCounters(id, listEntryId, updateCountersInput)

Update status counters on one of the current player's own models

Only available while the game is in_progress, and only for entries in the requesting player's own gang — the opponent's models 404. Send just the counters to change; omitted ones keep their current values. The change is broadcast to both players as a `game_state` event (re-fetch the player list to see the new counters). 

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

final api = CarnevaleApi().getGamesApi();
final int id = 56; // int | 
final int listEntryId = 56; // int | 
final UpdateCountersInput updateCountersInput = ; // UpdateCountersInput | 

try {
    final response = api.updateCounters(id, listEntryId, updateCountersInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GamesApi->updateCounters: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **listEntryId** | **int**|  | 
 **updateCountersInput** | [**UpdateCountersInput**](UpdateCountersInput.md)|  | 

### Return type

[**EntryState**](EntryState.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateSpellCast**
> EntryState updateSpellCast(id, listEntryId, updateSpellCastInput)

Mark (or unmark) one known/granted spell as cast, on one of the current player's own models

Only available while the game is in_progress, and only for entries in the requesting player's own gang — the opponent's models 404. `cast` is the desired state rather than a blind toggle, so a retried request from a flaky connection can't accidentally flip it back. Stamped against the requesting player's own turn cursor: for a pool/grant with resets_each_round true (almost every one), the mark clears automatically once that player advances to a new turn; for the rare resets_each_round: false case (Adventuring Noble's Arcane Totem pool), it persists for the rest of the game but stays manually toggleable, so a misclick is always correctable. The change is broadcast to both players as a `game_state` event (re-fetch the player list to see each spell's updated `cast` flag). 

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

final api = CarnevaleApi().getGamesApi();
final int id = 56; // int | 
final int listEntryId = 56; // int | 
final UpdateSpellCastInput updateSpellCastInput = ; // UpdateSpellCastInput | 

try {
    final response = api.updateSpellCast(id, listEntryId, updateSpellCastInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GamesApi->updateSpellCast: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **listEntryId** | **int**|  | 
 **updateSpellCastInput** | [**UpdateSpellCastInput**](UpdateSpellCastInput.md)|  | 

### Return type

[**EntryState**](EntryState.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateStats**
> EntryState updateStats(id, listEntryId, updateStatsInput)

Update current HP/WP/CP on one of the current player's own models

Only available while the game is in_progress, and only for entries in the requesting player's own gang — the opponent's models 404. Send just the stats to change (absolute values, not deltas); omitted ones keep their current values and none may go below 0. The change is broadcast to both players as a `game_state` event. 

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

final api = CarnevaleApi().getGamesApi();
final int id = 56; // int | 
final int listEntryId = 56; // int | 
final UpdateStatsInput updateStatsInput = ; // UpdateStatsInput | 

try {
    final response = api.updateStats(id, listEntryId, updateStatsInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GamesApi->updateStats: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **listEntryId** | **int**|  | 
 **updateStatsInput** | [**UpdateStatsInput**](UpdateStatsInput.md)|  | 

### Return type

[**EntryState**](EntryState.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateToken**
> EntryState updateToken(id, listEntryId, updateTokenInput)

Add or update a player token on one of the current player's own models

Player tokens are free-form markers (a colour + optional label, optionally toggleable) the player uses to track an in-game effect a rule granted. Only available while the game is in_progress, and only for the requesting player's own models — the opponent's 404. Each token is keyed by a client-generated `id`: sending the same id again updates that token (edit it / flip its `active`) instead of adding a duplicate, so a retried request is safe. Broadcast to both players as a `game_state` event. 

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

final api = CarnevaleApi().getGamesApi();
final int id = 56; // int | 
final int listEntryId = 56; // int | 
final UpdateTokenInput updateTokenInput = ; // UpdateTokenInput | 

try {
    final response = api.updateToken(id, listEntryId, updateTokenInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GamesApi->updateToken: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **listEntryId** | **int**|  | 
 **updateTokenInput** | [**UpdateTokenInput**](UpdateTokenInput.md)|  | 

### Return type

[**EntryState**](EntryState.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

