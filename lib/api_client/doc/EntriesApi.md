# carnevale_api.api.EntriesApi

## Load the API package
```dart
import 'package:carnevale_api/api.dart';
```

All URIs are relative to *http://localhost:3000/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createEntry**](EntriesApi.md#createentry) | **POST** /lists/{list_id}/entries | Add a card to a list
[**deleteEntry**](EntriesApi.md#deleteentry) | **DELETE** /lists/{list_id}/entries/{id} | Remove a card from a list


# **createEntry**
> BuiltList createEntry(listId, entryInput)

Add a card to a list

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getEntriesApi();
final int listId = 56; // int | 
final EntryInput entryInput = ; // EntryInput | 

try {
    final response = api.createEntry(listId, entryInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling EntriesApi->createEntry: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **listId** | **int**|  | 
 **entryInput** | [**EntryInput**](EntryInput.md)|  | 

### Return type

[**BuiltList**](BuiltList.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteEntry**
> BuiltList deleteEntry(listId, id)

Remove a card from a list

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getEntriesApi();
final int listId = 56; // int | 
final int id = 56; // int | 

try {
    final response = api.deleteEntry(listId, id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling EntriesApi->deleteEntry: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **listId** | **int**|  | 
 **id** | **int**|  | 

### Return type

[**BuiltList**](BuiltList.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

