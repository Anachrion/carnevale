# carnevale_api.model.GrantedSpell

## Load the model package
```dart
import 'package:carnevale_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**key** | **String** | Identifies this spell for PATCH .../spell_casts (UpdateSpellCastInput.spell_cast.key) — pass it back verbatim, don't try to construct it from `id`. | 
**id** | **int** | The underlying Catalog::Spell id when this grant references a real catalog spell (e.g. Galilean Priest's Waves of Force); null for a character-unique spell that has no catalog row (e.g. The Drowned Nun's Dagonite Baptism). | 
**discipline** | **String** | Null for a character-unique, discipline-less spell. | 
**name** | **String** |  | 
**cost** | **int** | Will Points spent to attempt the spell. Null only if the unique spell's data is incomplete. | 
**difficulty** | **int** | Magic Roll result needed to score an Ace. Null only if the unique spell's data is incomplete. | 
**description** | **String** |  | 
**cantrip** | **bool** |  | 
**consumesSlot** | **bool** | Whether this grant counts against a pool's slot_count. Every grant today is additive (false). | 
**resetsEachRound** | **bool** | Same meaning as SpellPool.resets_each_round, for this grant's own cast tracking. | 
**rule** | [**SpellRuleRef**](SpellRuleRef.md) | The card's special rule that explains this grant (e.g. Water Affinity, Major Arcana, Dagonite Baptism, Creative Creation). | 
**cast** | **bool** | Whether this spell has been marked cast this round (see PATCH .../spell_casts). Always false outside a live game. | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


