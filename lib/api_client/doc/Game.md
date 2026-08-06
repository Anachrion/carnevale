# carnevale_api.model.Game

## Load the model package
```dart
import 'package:carnevale_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**stateVersion** | **int** | Monotonic counter for this game, bumped every time its state is broadcast. Present on every `Game` the API returns — broadcasts, mutation responses and GET /games/{id} alike.  Neither Action Cable delivery nor HTTP responses guarantee ordering, so a client must apply a snapshot only when this is greater than the one it is currently displaying, and drop it otherwise. Without that, a mutation response serialized before the opponent's change committed can land after the broadcast carrying it and silently revert the screen. Only comparable within one game — it is not a global clock.  | 
**name** | **String** |  | 
**joinCode** | **String** |  | 
**status** | **String** | `completed` is derived: reached only once both players have `finished`, and reverts to `in_progress` if either undoes. | 
**ducatLimit** | **int** |  | 
**boardSize** | **String** |  | 
**scenario** | [**Scenario**](Scenario.md) |  | 
**viewerVisibility** | **String** | The requesting user's own archive/delete state for this game — never reflects the opponent's. | 
**players** | [**BuiltList&lt;GamePlayer&gt;**](GamePlayer.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


