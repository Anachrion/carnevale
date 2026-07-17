# carnevale_api.model.Profile

## Load the model package
```dart
import 'package:carnevale_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**name** | **String** |  | 
**faction** | **String** |  | 
**ducats** | **int** |  | 
**movement** | **int** |  | 
**attack** | **int** |  | 
**dexterity** | **int** |  | 
**lifePoints** | **int** |  | 
**mind** | **int** |  | 
**willPoints** | **int** |  | 
**protection** | **int** |  | 
**actionPoints** | **int** |  | 
**commandPoints** | **int** |  | 
**size** | **int** |  | 
**abilities** | **BuiltList&lt;String&gt;** |  | 
**keywords** | **BuiltList&lt;String&gt;** |  | 
**version** | **String** |  | 
**mage** | **bool** | Whether the profile has at least one spell pool and can be given spells (rulebook p24). | 
**spellSlots** | **int** | Summary total of non-Cantrip spells across every spell pool — informational only (the catalog browse view). 0 for non-Mages and for a profile whose only pool is `unlimited`. Real per-pool limits are enforced when hiring; see ListEntry.pools for the detail a gang builder needs.  | 
**disciplines** | **BuiltList&lt;String&gt;** | Union of every pool's eligible Discipline slugs, e.g. [\"blood_rites\", \"divinity\"] — informational only, same caveat as spell_slots. Empty for a mentor_derived pool (Apprentice Doctor), which has no static Discipline list of its own.  | 
**weapons** | [**BuiltList&lt;Weapon&gt;**](Weapon.md) |  | 
**specialRules** | [**BuiltList&lt;SpecialRule&gt;**](SpecialRule.md) |  | 
**cardReferences** | [**BuiltList&lt;CardReference&gt;**](CardReference.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


