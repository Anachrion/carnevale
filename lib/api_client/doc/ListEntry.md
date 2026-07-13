# carnevale_api.model.ListEntry

## Load the model package
```dart
import 'package:carnevale_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**position** | **int** |  | 
**entryType** | **String** |  | 
**entryId** | **int** |  | 
**name** | **String** |  | 
**cost** | **int** |  | 
**summoned** | **bool** | Conjured onto the board mid-game by a special rule, rather than hired during gang building. A summoned model tracks HP/counters/activation like any other, but costs the gang nothing and is exempt from the gang-building rules (ducat limit, faction consistency, unique/Leader/ratio), so a legal summon can't push a gang over its limit or flip it to invalid. It is also the only kind of model that can be removed mid-game.  | 
**state** | [**EntryState**](EntryState.md) | Present once the game has started (both players confirming their Agenda hand flips it to in_progress); null beforehand and for Catalog::Equipment entries, which have no HP/WP/CP to track. | [optional] 
**mage** | **bool** | Whether this model is a Mage and can therefore be given spells. Always false for Equipment. | 
**spellSlots** | **int** | Maximum number of non-Cantrip spells the model may know (Mage X + Expert Sorcerer X). 0 for non-Mages. | 
**disciplines** | **BuiltList&lt;String&gt;** | Discipline slugs the model may pick spells from, e.g. [\"blood_rites\", \"divinity\"]. | 
**spellDiscipline** | **String** | The Discipline this model has committed to, or null if none picked yet. | [optional] 
**cantrip** | [**Spell**](Spell.md) | The free Cantrip the model always knows for its committed Discipline; null when no Discipline is picked. Not counted against spell_slots. | [optional] 
**spells** | [**BuiltList&lt;Spell&gt;**](Spell.md) | The non-free spells this model currently knows. | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


