# carnevale_api.api.EquipmentApi

## Load the API package
```dart
import 'package:carnevale_api/api.dart';
```

All URIs are relative to *http://localhost:3000/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getEquipment**](EquipmentApi.md#getequipment) | **GET** /equipment | List all equipment


# **getEquipment**
> BuiltList<Equipment> getEquipment()

List all equipment

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

final api = CarnevaleApi().getEquipmentApi();

try {
    final response = api.getEquipment();
    print(response);
} on DioException catch (e) {
    print('Exception when calling EquipmentApi->getEquipment: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;Equipment&gt;**](Equipment.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

