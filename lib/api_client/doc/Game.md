# carnevale_api.model.Game

## Load the model package
```dart
import 'package:carnevale_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**joinCode** | **String** |  | 
**status** | **String** |  | 
**ducatLimit** | **int** |  | 
**boardSize** | **String** |  | 
**scenario** | [**Scenario**](Scenario.md) |  | 
**roleRollWinnerId** | **int** | game_player id of the role roll-off winner (asymmetric scenarios only). Picked at random as soon as the second player joins. | 
**deploymentRollWinnerId** | **int** | game_player id of the deployment roll-off winner. Picked at random as soon as the second player joins. | 
**viewerVisibility** | **String** | The requesting user's own archive/delete state for this game — never reflects the opponent's. | 
**players** | [**BuiltList&lt;GamePlayer&gt;**](GamePlayer.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


