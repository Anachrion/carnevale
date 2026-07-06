# carnevale_api.model.GamePlayer

## Load the model package
```dart
import 'package:carnevale_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**userId** | **int** |  | 
**username** | **String** |  | 
**host** | **bool** |  | 
**list** | [**GangSummary**](GangSummary.md) |  | 
**role** | **String** |  | 
**ready** | **bool** |  | 
**wonRoleRoll** | **bool** | True for the role roll-off winner (asymmetric scenarios only). Picked at random as soon as the second player joins. | 
**wonDeploymentRoll** | **bool** | True for the deployment roll-off winner. Picked at random as soon as the second player joins. Informational only — the deployment zone itself is chosen at the table, not in-app. | 
**score** | **int** | Total Victory Points scored from Agendas so far (every Agenda scores a flat 1 VP). Always visible for both players. | 
**currentTurn** | **int** | This player's own turn cursor (starts at 1). Rewindable via the turns/advance and turns/rewind endpoints; agenda events are stamped with whatever turn the player is pointed at. Independent of the opponent's. | 
**finished** | **bool** | Whether this player has ended the game from their side (see the finish/unfinish endpoints). When both players are finished the game's status derives to `completed`. | 
**agendas** | [**BuiltList&lt;Agenda&gt;**](Agenda.md) | This player's current hand. Always populated for the requesting player's own entry. For the opponent's entry it is populated too, unless the scenario has the `secret` agenda rule, in which case it is empty (the hand stays hidden until achieved). | 
**agendaHistory** | [**BuiltList&lt;AgendaHistoryEntry&gt;**](AgendaHistoryEntry.md) | Draw/score/discard events for this player, in turn order. Full history for the requesting player's own entry. For the opponent's entry under the `secret` rule it is trimmed to resolved events only (scored + discarded), so the hidden hand doesn't leak; otherwise it is the full history. | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


