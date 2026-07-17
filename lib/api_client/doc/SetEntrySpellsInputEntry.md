# carnevale_api.model.SetEntrySpellsInputEntry

## Load the model package
```dart
import 'package:carnevale_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**mentoredByEntryId** | **int** | Apprentice Doctor's Apprenticeship only: id of another ListEntry in the same list to copy Mage disciplines/slot_count from (see ListEntry.mentored_by_entry_id), or null to clear it. Omit entirely to leave the current mentor untouched — unlike pool_selections, this field is not wholesale-replaced on every call.  | [optional] 
**poolSelections** | [**BuiltList&lt;SetEntrySpellsInputEntryPoolSelectionsInner&gt;**](SetEntrySpellsInputEntryPoolSelectionsInner.md) | One entry per pool (almost always one pool; a two-pool model like Seamstress or Doctor of the Firmament needs one entry per pool). Replaces this model's *entire* spell selection wholesale across every pool — a pool omitted here loses its selection, it isn't left untouched — so always submit every pool the model has, not just the one that changed.  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


