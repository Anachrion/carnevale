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
**score** | **int** | Total Victory Points scored from Agendas so far (every Agenda scores a flat 1 VP). Visible for both players, unlike the hidden hand. | 
**agendas** | [**BuiltList&lt;Agenda&gt;**](Agenda.md) | This player's current hand. Only populated for the requesting player's own entry — always empty for the opponent's. | 
**agendaHistory** | [**BuiltList&lt;AgendaHistoryEntry&gt;**](AgendaHistoryEntry.md) | Every draw/score/discard event for this player, in turn order. Only populated for the requesting player's own entry — always empty for the opponent's. | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


