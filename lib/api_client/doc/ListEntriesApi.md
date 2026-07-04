# carnevale_api.api.ListEntriesApi

## Load the API package
```dart
import 'package:carnevale_api/api.dart';
```

All URIs are relative to *http://localhost:3000/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createListEntry**](ListEntriesApi.md#createlistentry) | **POST** /list_entries | Add a card to a list
[**deleteListEntry**](ListEntriesApi.md#deletelistentry) | **DELETE** /list_entries/{id} | Remove a card from a list
[**updateListEntryPosition**](ListEntriesApi.md#updatelistentryposition) | **PATCH** /list_entries/{id} | Move a card to a new position in the list


# **createListEntry**
> BuiltList createListEntry(entryInput)

Add a card to a list

Returns 404 if the list doesn't belong to the current user.

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getListEntriesApi();
final EntryInput entryInput = ; // EntryInput | 

try {
    final response = api.createListEntry(entryInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ListEntriesApi->createListEntry: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **entryInput** | [**EntryInput**](EntryInput.md)|  | 

### Return type

[**BuiltList**](BuiltList.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteListEntry**
> BuiltList deleteListEntry(id)

Remove a card from a list

Returns 404 if the entry's list doesn't belong to the current user.

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getListEntriesApi();
final int id = 56; // int | 

try {
    final response = api.deleteListEntry(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ListEntriesApi->deleteListEntry: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**BuiltList**](BuiltList.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateListEntryPosition**
> BuiltList updateListEntryPosition(id, entryPositionInput)

Move a card to a new position in the list

Returns 404 if the entry's list doesn't belong to the current user.

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getListEntriesApi();
final int id = 56; // int | 
final EntryPositionInput entryPositionInput = ; // EntryPositionInput | 

try {
    final response = api.updateListEntryPosition(id, entryPositionInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ListEntriesApi->updateListEntryPosition: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **entryPositionInput** | [**EntryPositionInput**](EntryPositionInput.md)|  | 

### Return type

[**BuiltList**](BuiltList.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

