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
**status** | **String** | `completed` is derived: reached only once both players have `finished`, and reverts to `in_progress` if either undoes. | 
**ducatLimit** | **int** |  | 
**boardSize** | **String** |  | 
**scenario** | [**Scenario**](Scenario.md) |  | 
**viewerVisibility** | **String** | The requesting user's own archive/delete state for this game — never reflects the opponent's. | 
**players** | [**BuiltList&lt;GamePlayer&gt;**](GamePlayer.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


