# carnevale_api.model.UpdateCountersInputCounters

## Load the model package
```dart
import 'package:carnevale_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**stunned** | **bool** |  | [optional] 
**hidden** | **bool** |  | [optional] 
**guarding** | **bool** |  | [optional] 
**carryingObjective** | **bool** |  | [optional] 
**underwaterCounters** | **int** |  | [optional] 
**activated** | **bool** | Whether this model has been activated on the acting player's current turn. Persisted server-side as the turn it was activated on, so it resets itself when that player advances the turn (and is restored intact if they rewind). The turn is always taken from the acting player's own cursor — it cannot be supplied by the client.  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


