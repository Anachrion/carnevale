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
**profileName** | **String** | The underlying profile's name without the card-reference letter suffix (e.g. \"Beggar\" rather than \"Beggar (A)\"). Use this to label a hired model and number duplicates client-side. Null for Equipment entries.  | [optional] 
**keywords** | **BuiltList&lt;String&gt;** | The underlying profile's printed keywords (e.g. [\"Hero\", \"Doctor\"]) — used client-side to filter Apprentice Doctor's Apprenticeship mentor candidates (\"a character with both the Doctor and Hero keywords\"). Empty for Equipment.  | 
**identifier** | **String** | Slug of the card reference this model is hired as — the same identifier the cards manifest keys downloaded images by. A profile can have several card references, each with a different illustration; this is the one currently chosen. Null for Equipment entries, which have no card. Change it via PATCH /list_entries/{id}/illustration.  | [optional] 
**cardFront** | **String** | Front face filename of the chosen card reference (served from /cards). Null for Equipment. | [optional] 
**cardBack** | **String** | Back face filename of the chosen card reference (served from /cards). Null for Equipment. | [optional] 
**cost** | **int** |  | 
**summoned** | **bool** | Conjured onto the board mid-game by a special rule, rather than hired during gang building. A summoned model tracks HP/counters/activation like any other, but costs the gang nothing and is exempt from the gang-building rules (ducat limit, faction consistency, unique/Leader/ratio), so a legal summon can't push a gang over its limit or flip it to invalid. It is also the only kind of model that can be removed mid-game.  | 
**state** | [**EntryState**](EntryState.md) | Present once the game has started (both players confirming their Agenda hand flips it to in_progress); null beforehand and for Catalog::Equipment entries, which have no HP/WP/CP to track. | [optional] 
**mage** | **bool** | Whether this model is a Mage and can therefore be given spells. Always false for Equipment; non-Mage models carry empty pools/granted_spells. | 
**mentoredByEntryId** | **int** | Apprentice Doctor's Apprenticeship: the id of another ListEntry in the same list whose resolved Mage pool this model's mentor_derived pool borrows its disciplines/slot_count from. Null for every other profile, and null until a mentor is chosen. Set it via PATCH /list_entries/{id}/spells (SetEntrySpellsInput.entry.mentored_by_entry_id).  | [optional] 
**distinctDisciplinePerCopy** | **bool** | Romani's Tarot: when true, every other ListEntry of the same profile in this list must commit its first pool to a different Discipline from this one's — enforced server-side (ListValidationService), exposed here only so the picker can grey out a sibling's already-chosen Discipline with an inline reason. False for every other profile.  | 
**pools** | [**BuiltList&lt;SpellPool&gt;**](SpellPool.md) | This model's spell-selection pools (rulebook p24), in profile order. Empty for non-Mage models. Most profiles have exactly one; a few (Seamstress, Tarot Reader) have two, and one (Doctor of the Firmament) spans multiple Disciplines at once via a single pool's `of`.  | 
**grantedSpells** | [**BuiltList&lt;GrantedSpell&gt;**](GrantedSpell.md) | Spells this model always knows regardless of pool picks (e.g. Galilean Priest's Waves of Force, Blood Crone's five Cantrips) — read-only, never edited through the spells endpoint, and don't count against any pool's slot_count.  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


