# carnevale_api.model.Token

## Load the model package
```dart
import 'package:carnevale_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | Client-generated stable id; re-sending the same id updates the token instead of adding a duplicate. | 
**color** | **String** |  | 
**text** | **String** | Optional label; a colour-only token omits it and renders as a dot. | [optional] 
**toggleable** | **bool** | Whether the player can flip it on/off (a recurring effect) rather than only add/remove it. | 
**active** | **bool** |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


