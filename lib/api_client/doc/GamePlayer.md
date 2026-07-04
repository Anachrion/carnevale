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
**deploymentZone** | **String** |  | 
**ready** | **bool** |  | 
**wonRoleRoll** | **bool** | True for the role roll-off winner (asymmetric scenarios only). Picked at random as soon as the second player joins. | 
**wonDeploymentRoll** | **bool** | True for the deployment roll-off winner. Picked at random as soon as the second player joins. | 
**agendas** | [**BuiltList&lt;Agenda&gt;**](Agenda.md) | Only populated for the requesting player's own entry — always empty for the opponent's. | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


