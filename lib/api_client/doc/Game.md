# carnevale_api.model.Game

## Load the model package
```dart
import 'package:carnevale_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**name** | **String** |  | 
**joinCode** | **String** |  | 
**status** | **String** |  | 
**ducatLimit** | **int** |  | 
**boardSize** | **String** |  | 
**currentTurn** | **int** | The shared turn counter, starting at 1. Advanced by either player via POST /games/{id}/turns/advance. | 
**scenario** | [**Scenario**](Scenario.md) |  | 
**viewerVisibility** | **String** | The requesting user's own archive/delete state for this game — never reflects the opponent's. | 
**players** | [**BuiltList&lt;GamePlayer&gt;**](GamePlayer.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


