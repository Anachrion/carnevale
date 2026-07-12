# carnevale_api.model.EntryState

## Load the model package
```dart
import 'package:carnevale_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**lifePoints** | [**EntryStatValue**](EntryStatValue.md) |  | 
**willPoints** | [**EntryStatValue**](EntryStatValue.md) |  | 
**commandPoints** | [**EntryStatValue**](EntryStatValue.md) |  | 
**stunned** | **bool** |  | 
**hidden** | **bool** |  | 
**guarding** | **bool** |  | 
**carryingObjective** | **bool** |  | 
**underwaterCounters** | **int** |  | 
**activated** | **bool** | Whether this model has already been activated on its *owner's* current turn (each player has an independent turn cursor). Derived server-side, so it flips back to false on its own when the owning player advances the turn.  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


