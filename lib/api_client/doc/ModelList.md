# carnevale_api.model.ModelList

## Load the model package
```dart
import 'package:carnevale_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**sourceListId** | **int** | The source list this gang was snapshotted from when selected for a game; null for a source list itself. Lets a client match a player's in-game gang to their available-lists picker. | [optional] 
**name** | **String** |  | [optional] 
**faction** | **String** |  | 
**points** | **int** |  | 
**totalCost** | **int** |  | 
**selectionValid** | **bool** | Whether the current set of entries satisfies the gang composition rules (points limit, faction, uniqueness, Leader, Hero/Henchman ratio, etc). | 
**selectionErrors** | **BuiltList&lt;String&gt;** |  | 
**entries** | [**BuiltList&lt;ListEntry&gt;**](ListEntry.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


