# carnevale_api.api.GamesApi

## Load the API package
```dart
import 'package:carnevale_api/api.dart';
```

All URIs are relative to *http://localhost:3000/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createGame**](GamesApi.md#creategame) | **POST** /games | Create a game, hosted by the current user
[**drawAgendas**](GamesApi.md#drawagendas) | **POST** /games/{id}/agendas/draw | Privately draw this player&#39;s Agenda cards
[**getAvailableGangs**](GamesApi.md#getavailablegangs) | **GET** /games/{id}/available_lists | The current user&#39;s lists, flagged selectable against this game&#39;s ducat_limit
[**getGame**](GamesApi.md#getgame) | **GET** /games/{id} | Get a game&#39;s full current state
[**getGames**](GamesApi.md#getgames) | **GET** /games | List the current user&#39;s games (to resume/reopen)
[**joinGame**](GamesApi.md#joingame) | **POST** /games/join | Join a game via its join_code
[**markReady**](GamesApi.md#markready) | **POST** /games/{id}/ready | Confirm physical deployment is done
[**pickDeploymentZone**](GamesApi.md#pickdeploymentzone) | **PATCH** /games/{id}/deployment_zone | Pick a Deployment Zone (deployment roll-off winner only)
[**pickRole**](GamesApi.md#pickrole) | **PATCH** /games/{id}/role | Pick Attacker or Defender (role roll-off winner only)
[**rollForDeployment**](GamesApi.md#rollfordeployment) | **POST** /games/{id}/deployment_roll | Roll the deployment-priority die
[**rollForRole**](GamesApi.md#rollforrole) | **POST** /games/{id}/role_roll | Roll for Attacker/Defender priority (asymmetric scenarios only)
[**selectGang**](GamesApi.md#selectgang) | **PATCH** /games/{id}/select_gang | Select a list as the current user&#39;s gang for this game


# **createGame**
> Game createGame(createGameInput)

Create a game, hosted by the current user

ducat_limit defaults from the scenario if omitted.

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

# **drawAgendas**
> DrawAgendasResponse drawAgendas(id)

Privately draw this player's Agenda cards

Never broadcast or visible to the opponent.

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getGamesApi();
final int id = 56; // int | 

try {
    final response = api.drawAgendas(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GamesApi->drawAgendas: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**DrawAgendasResponse**](DrawAgendasResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

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
> BuiltList<Game> getGames()

List the current user's games (to resume/reopen)

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getGamesApi();

try {
    final response = api.getGames();
    print(response);
} on DioException catch (e) {
    print('Exception when calling GamesApi->getGames: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;Game&gt;**](Game.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **joinGame**
> Game joinGame(joinGameInput)

Join a game via its join_code

Idempotent if the current user has already joined. Returns 422 if the game is already full.

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

Once both players are ready, the game's status becomes in_progress.

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

# **pickDeploymentZone**
> Game pickDeploymentZone(id, deploymentZoneInput)

Pick a Deployment Zone (deployment roll-off winner only)

The other player is automatically assigned the remaining zone.

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getGamesApi();
final int id = 56; // int | 
final DeploymentZoneInput deploymentZoneInput = ; // DeploymentZoneInput | 

try {
    final response = api.pickDeploymentZone(id, deploymentZoneInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GamesApi->pickDeploymentZone: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **deploymentZoneInput** | [**DeploymentZoneInput**](DeploymentZoneInput.md)|  | 

### Return type

[**Game**](Game.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **pickRole**
> Game pickRole(id, roleInput)

Pick Attacker or Defender (role roll-off winner only)

The other player is automatically assigned the remaining role.

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

# **rollForDeployment**
> Game rollForDeployment(id)

Roll the deployment-priority die

Ties are re-rolled automatically, server-side, before this responds.

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getGamesApi();
final int id = 56; // int | 

try {
    final response = api.rollForDeployment(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GamesApi->rollForDeployment: $e\n');
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

# **rollForRole**
> Game rollForRole(id)

Roll for Attacker/Defender priority (asymmetric scenarios only)

Ties are re-rolled automatically, server-side, before this responds.

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getGamesApi();
final int id = 56; // int | 

try {
    final response = api.rollForRole(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling GamesApi->rollForRole: $e\n');
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

