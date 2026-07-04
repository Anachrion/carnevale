# carnevale_api.model.Scenario

## Load the model package
```dart
import 'package:carnevale_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**name** | **String** |  | 
**ducats** | **int** | Default ducat limit recommended by the rulebook for this scenario. | 
**asymmetric** | **bool** | True for scenarios with Attacker/Defender roles (e.g. Street Fight), which run a role roll-off once both players have joined. | 
**setup** | **String** |  | 
**primaryObjective** | **String** |  | 
**agendas** | **BuiltList&lt;String&gt;** |  | 
**specialRules** | **BuiltList&lt;String&gt;** |  | 
**duration** | **String** | Free-text rendering of the scenario's duration (e.g. \"5 rounds.\"). See `turns` for the structured count. | 
**turns** | **int** | Number of turns the scenario lasts. | 
**deploymentZones** | **BuiltList&lt;String&gt;** |  | 
**illustration** | **String** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


