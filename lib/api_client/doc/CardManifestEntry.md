# carnevale_api.model.CardManifestEntry

## Load the model package
```dart
import 'package:carnevale_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**identifier** | **String** |  | 
**faction** | **String** |  | [optional] 
**internalVersion** | **int** | Bumps whenever the card's image bytes change; drives client re-download. | 
**frontUrl** | **String** | Versioned (?v=internal_version) URL of the front image, or null if missing. | [optional] 
**backUrl** | **String** |  | [optional] 
**frontBytes** | **int** | Size in bytes of the front image, or null if the file is missing. | [optional] 
**backBytes** | **int** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


