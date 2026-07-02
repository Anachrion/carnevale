# carnevale_api.api.ScenariosApi

## Load the API package
```dart
import 'package:carnevale_api/api.dart';
```

All URIs are relative to *http://localhost:3000/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getScenarios**](ScenariosApi.md#getscenarios) | **GET** /scenarios | List all scenarios


# **getScenarios**
> BuiltList<Scenario> getScenarios()

List all scenarios

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getScenariosApi();

try {
    final response = api.getScenarios();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ScenariosApi->getScenarios: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;Scenario&gt;**](Scenario.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

