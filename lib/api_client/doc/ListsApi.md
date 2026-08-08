# carnevale_api.api.ListsApi

## Load the API package
```dart
import 'package:carnevale_api/api.dart';
```

All URIs are relative to *http://localhost:3000/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createList**](ListsApi.md#createlist) | **POST** /lists | Create a list owned by the current user
[**deleteList**](ListsApi.md#deletelist) | **DELETE** /lists/{id} | Delete a list
[**exportList**](ListsApi.md#exportlist) | **GET** /lists/{id}/export | Export a gang as shareable plain text
[**getList**](ListsApi.md#getlist) | **GET** /lists/{id} | Get a list
[**getLists**](ListsApi.md#getlists) | **GET** /lists | List the current user&#39;s lists
[**importList**](ListsApi.md#importlist) | **POST** /lists/import | Build a new gang from exported text
[**updateList**](ListsApi.md#updatelist) | **PATCH** /lists/{id} | Update a list


# **createList**
> BuiltList createList(listInput)

Create a list owned by the current user

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

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

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteList**
> deleteList(id)

Delete a list

Returns 404 if the list doesn't belong to the current user.

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

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

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **exportList**
> GangText exportList(id)

Export a gang as shareable plain text

The gang written in the plain-text exchange format, ready to paste into a chat message or render as a QR code. Returns 404 if the list doesn't belong to the current user.  Illustrations are deliberately not carried: a gang list is what you took, not which artwork you picked. Neither are auto-included companions or a model's derived spells (cantrips, granted spells) — POST /lists/import regenerates all of those from the catalog.  Wrapped in JSON rather than served as `text/plain` so every endpoint here answers the same way. See CARNEVALEB-74. 

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

final api = CarnevaleApi().getListsApi();
final int id = 56; // int | 

try {
    final response = api.exportList(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ListsApi->exportList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**GangText**](GangText.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getList**
> BuiltList getList(id)

Get a list

Returns 404 if the list doesn't belong to the current user.

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

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

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getLists**
> BuiltList<BuiltList> getLists()

List the current user's lists

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

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

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **importList**
> GangImportResult importList(gangText)

Build a new gang from exported text

Parses the plain-text format produced by GET /lists/{id}/export and creates a **new** gang from it. Never edits an existing list, so a bad paste costs nothing.  Anything that cannot be resolved — a model this build's catalog doesn't know, a spell that has been renamed — is reported in `warnings` and skipped, rather than failing the whole import: one typo should not cost a whole gang. Roster legality is *not* judged here, so an imported gang that breaks a rule or busts its Ducat limit arrives flagged `selection_valid: false` exactly as a hand-built one would. 

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

final api = CarnevaleApi().getListsApi();
final GangText gangText = ; // GangText | 

try {
    final response = api.importList(gangText);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ListsApi->importList: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **gangText** | [**GangText**](GangText.md)|  | 

### Return type

[**GangImportResult**](GangImportResult.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateList**
> BuiltList updateList(id, listInput)

Update a list

Returns 404 if the list doesn't belong to the current user.

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

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

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

