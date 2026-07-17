# carnevale_api.model.SpellPool

## Load the model package
```dart
import 'package:carnevale_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**of_** | **int** | How many Disciplines this pool's chosen_disciplines may span at once (1 for almost every profile; 2 for Doctor of the Firmament). | 
**slotCount** | **int** | Non-Cantrip spells this pool grants, shared across every chosen Discipline when of > 1. Irrelevant when unlimited. | 
**mageSlotCount** | **int** | The Mage(X)-only portion of slot_count, excluding any Expert Sorcerer(Y) bonus rolled into the same pool — equal to slot_count when there's no separate Expert Sorcerer ability. Relevant only when reading a *mentor candidate's* own pool: Apprentice Doctor's Apprenticeship copies the Mage ability alone, so her mentor_derived pool's resolved slot_count above already reflects the mentor's mage_slot_count, not their full slot_count — this field is what lets the picker preview that before saving, from the mentor's ListEntry in the same gang.  | 
**unlimited** | **bool** | When true, this model automatically knows every spell of its chosen Discipline(s) — spells/cantrips are pre-filled and there is nothing to pick. | 
**grantsCantrip** | **bool** | Whether committing a Discipline in this pool grants that Discipline's free Cantrip (not counted against slot_count). | 
**mentorDerived** | **bool** | Apprentice Doctor's Apprenticeship: when true, eligible_disciplines/of/slot_count are resolved from the mentor entry named by the parent ListEntry's mentored_by_entry_id (null/empty until a mentor is chosen), not static per-profile data. chosen_disciplines and spells are still this model's own picks.  | 
**distinctFromOtherPools** | **bool** | Tarot Reader's Minor Arcana: when true, this pool's chosen_disciplines must not overlap with any other pool's on the same model (\"1 additional Cantrip... from a different available Discipline\") — enforced server-side, exposed here so the picker can grey out a Discipline already committed by another of this model's pools.  | 
**resetsEachRound** | **bool** | Whether a spell cast through this pool becomes available again on the next round (true, the default — \"each character may only attempt to cast each spell once per round\") or stays cast for the rest of the game once marked (false — Adventuring Noble's Arcane Totem pool only, \"once per game\"). Applies to every PoolSpell in cantrips/spells.  | 
**rule** | [**SpellRuleRef**](SpellRuleRef.md) | The card's special rule that explains this pool's shape (e.g. Aetheric Gaze, Entwined Magics, Apprenticeship, Arcane Totem), or null for the standard Mage(X) case. | 
**eligibleDisciplines** | **BuiltList&lt;String&gt;** | Discipline slugs this pool may pick from, e.g. [\"blood_rites\", \"divinity\"]. | 
**chosenDisciplines** | **BuiltList&lt;String&gt;** | The subset of eligible_disciplines this model has actually committed to (size ≤ of). | 
**cantrips** | [**BuiltList&lt;PoolSpell&gt;**](PoolSpell.md) | The free Cantrip(s) for each committed Discipline (only present once grants_cantrip and a Discipline is chosen). Not counted against slot_count. | 
**spells** | [**BuiltList&lt;PoolSpell&gt;**](PoolSpell.md) | The non-free spells this model currently knows through this pool. | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


