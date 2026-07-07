# carnevale_api.model.DiscardAgendaInput

## Load the model package
```dart
import 'package:carnevale_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**origin** | **String** | `unachievable` is the pre-game mulligan (valid during `agenda_draw`); `special_rule`/`command_point` are in-play discards (valid while `in_progress`).  | 
**recycle** | **bool** | Whether to immediately draw a replacement card (origin `recycle`) linked back to this discard. Only honoured for in-play discards; the `unachievable` mulligan always redraws.  | [optional] [default to false]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


