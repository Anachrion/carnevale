# carnevale_api.model.SetEntrySpellsInputEntryPoolSelectionsInner

## Load the model package
```dart
import 'package:carnevale_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**poolId** | **int** | Id of one of this model's pools (see ListEntry.pools[].id). | 
**disciplines** | **BuiltList&lt;String&gt;** | The discipline(s) committed for this pool — usually one, up to the pool's `of` count for a multi-discipline pool (Doctor of the Firmament).  | [optional] 
**spellIds** | **BuiltList&lt;int&gt;** | The exact set of known (non-Cantrip) spell ids for this pool. | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


