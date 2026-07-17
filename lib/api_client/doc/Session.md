# carnevale_api.model.Session

## Load the model package
```dart
import 'package:carnevale_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**user** | [**SessionUser**](SessionUser.md) |  | 
**refreshToken** | **String** | Long-lived, single-use credential used to obtain a fresh JWT once the short-lived one expires (see POST /token). Store it securely; it is only ever returned here and on refresh, and is rotated on every use.  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


