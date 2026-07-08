# carnevale_api.model.DiscardAgendaInput

## Load the model package
```dart
import 'package:carnevale_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**origin** | **String** | `unachievable` swaps an impossible/duplicated agenda for a fresh one and always redraws (valid both during `agenda_draw` and `in_progress`); `special_rule`/`command_point` are in-play discards (valid while `in_progress`).  | 
**recycle** | **bool** | Whether to immediately draw a replacement card (origin `recycle`) linked back to this discard. Only honoured for in-play discards; the `unachievable` mulligan always redraws.  | [optional] [default to false]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


