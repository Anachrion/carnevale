# carnevale_api.model.UpdateSpellCastInputSpellCast

## Load the model package
```dart
import 'package:carnevale_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**key** | **String** | Identifies the spell within this model — copy it verbatim from the `key` field of the PoolSpell/GrantedSpell being marked (see ListEntry.pools[].spells[]/cantrips[] and ListEntry.granted_spells[]). Opaque; don't try to construct it client-side.  | 
**cast** | **bool** | The desired state (true = mark cast, false = clear it) rather than a toggle. | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


