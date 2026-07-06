# carnevale_api.model.AgendaHistoryEntry

## Load the model package
```dart
import 'package:carnevale_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**turn** | **int** |  | 
**action** | **String** |  | 
**origin** | **String** | Why this event happened. Always null for `scored` events — scoring just resolves the Agenda's own printed condition, it isn't granted by an external rule the way drawing/discarding is. `unachievable` marks a pre-game mulligan discard. | 
**causedByEventId** | **int** | Set only when origin is `recycle` — the id of the scored/discarded event (within this same list) that triggered this replacement draw. | 
**agenda** | [**AgendaHistoryEntryAgenda**](AgendaHistoryEntryAgenda.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


