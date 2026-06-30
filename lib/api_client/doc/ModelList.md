# carnevale_api.model.ModelList

## Load the model package
```dart
import 'package:carnevale_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**name** | **String** |  | [optional] 
**faction** | **String** |  | 
**points** | **int** |  | 
**totalCost** | **int** |  | 
**selectionValid** | **bool** | Whether the current set of entries satisfies the gang composition rules (points limit, faction, uniqueness, Leader, Hero/Henchman ratio, etc). | 
**selectionErrors** | **BuiltList&lt;String&gt;** |  | 
**entries** | [**BuiltList&lt;ListEntry&gt;**](ListEntry.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


