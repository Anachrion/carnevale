# carnevale_api.api.ListsApi

## Load the API package
```dart
import 'package:carnevale_api/api.dart';
```

All URIs are relative to *http://localhost:3000/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createList**](ListsApi.md#createlist) | **POST** /lists | Create a list
[**deleteList**](ListsApi.md#deletelist) | **DELETE** /lists/{id} | Delete a list
[**getList**](ListsApi.md#getlist) | **GET** /lists/{id} | Get a list
[**getLists**](ListsApi.md#getlists) | **GET** /lists | List all lists
[**updateList**](ListsApi.md#updatelist) | **PATCH** /lists/{id} | Update a list


# **createList**
> BuiltList createList(listInput)

Create a list

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getListsApi();
final ListInput listInput = ; // ListInput | 

try {
    final response = api.createList(listInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ListsApi->createList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **listInput** | [**ListInput**](ListInput.md)|  | 

### Return type

[**BuiltList**](BuiltList.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteList**
> deleteList(id)

Delete a list

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getListsApi();
final int id = 56; // int | 

try {
    api.deleteList(id);
} on DioException catch (e) {
    print('Exception when calling ListsApi->deleteList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getList**
> BuiltList getList(id)

Get a list

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getListsApi();
final int id = 56; // int | 

try {
    final response = api.getList(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ListsApi->getList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**BuiltList**](BuiltList.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getLists**
> BuiltList<BuiltList> getLists()

List all lists

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getListsApi();

try {
    final response = api.getLists();
    print(response);
} on DioException catch (e) {
    print('Exception when calling ListsApi->getLists: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;BuiltList&gt;**](BuiltList.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateList**
> BuiltList updateList(id, listInput)

Update a list

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getListsApi();
final int id = 56; // int | 
final ListInput listInput = ; // ListInput | 

try {
    final response = api.updateList(id, listInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ListsApi->updateList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **listInput** | [**ListInput**](ListInput.md)|  | 

### Return type

[**BuiltList**](BuiltList.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

