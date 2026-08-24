# carnevale_api.model.SessionUser

## Load the model package
```dart
import 'package:carnevale_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **int** |  | 
**email** | **String** |  | 
**username** | **String** |  | 
**collectionEnabled** | **bool** | Whether the player has switched the Collection feature on (CARNEVALEB-76). False until they do.  | 
**collectionVisible** | **bool** | Whether the Collection feature is offered at all — the home-screen entry and the menu item. True by default; turning it off hides everything the feature adds, including the catalogue marks, while remembering `collection_enabled`. Both switches live on the account rather than in the client's local settings, so someone who tracks a collection finds it set up the same way on every device.  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


