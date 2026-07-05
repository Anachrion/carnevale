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
**mage** | **bool** | Whether the profile has the Mage ability and can be given spells (rulebook p24). | 
**spellSlots** | **int** | Maximum number of non-Cantrip spells the model may know (Mage X + Expert Sorcerer X). 0 for non-Mages. | 
**disciplines** | **BuiltList&lt;String&gt;** | Discipline slugs the model may pick spells from, e.g. [\"blood_rites\", \"divinity\"]. | 
**weapons** | [**BuiltList&lt;Weapon&gt;**](Weapon.md) |  | 
**specialRules** | [**BuiltList&lt;SpecialRule&gt;**](SpecialRule.md) |  | 
**cardReferences** | [**BuiltList&lt;CardReference&gt;**](CardReference.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


