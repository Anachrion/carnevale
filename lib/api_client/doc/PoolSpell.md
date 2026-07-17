# carnevale_api.model.PoolSpell

## Load the model package
```dart
import 'package:carnevale_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**key** | **String** | Identifies this spell for PATCH .../spell_casts (UpdateSpellCastInput.spell_cast.key) — pass it back verbatim, don't try to construct it from `id`. | 
**id** | **int** |  | 
**name** | **String** |  | 
**discipline** | **String** |  | 
**cost** | **int** | Will Points spent to attempt the spell. | 
**difficulty** | **int** | Magic Roll result needed to score an Ace. | 
**cantrip** | **bool** | Whether this is the Discipline's free Cantrip (always known, not counted against the pool's slot_count). | 
**description** | **String** |  | 
**cast** | **bool** | Whether this spell has been marked cast this round (see PATCH .../spell_casts). Always false outside a live game. | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


