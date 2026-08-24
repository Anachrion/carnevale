# carnevale_api.api.CollectionApi

## Load the API package
```dart
import 'package:carnevale_api/api.dart';
```

All URIs are relative to *http://localhost:3000/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getCollection**](CollectionApi.md#getcollection) | **GET** /collection | The current player&#39;s collection
[**updateCollection**](CollectionApi.md#updatecollection) | **PUT** /collection | Set the counts for several profiles at once
[**updateCollectionItem**](CollectionApi.md#updatecollectionitem) | **PUT** /collection/{profile_id} | Set the counts for one profile


# **getCollection**
> BuiltList<CollectionItem> getCollection()

The current player's collection

One entry per catalog profile the player owns at least one miniature of. A profile absent from the response is simply one they own none of — there is no zeroed entry to read. 

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

final api = CarnevaleApi().getCollectionApi();

try {
    final response = api.getCollection();
    print(response);
} on DioException catch (e) {
    print('Exception when calling CollectionApi->getCollection: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;CollectionItem&gt;**](CollectionItem.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateCollection**
> BuiltList<CollectionItem> updateCollection(collectionBulkInput)

Set the counts for several profiles at once

All or nothing: if any entry names a profile that does not exist, none of the others are applied either, so the client never has to work out how far a half-applied batch got. 

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

final api = CarnevaleApi().getCollectionApi();
final CollectionBulkInput collectionBulkInput = ; // CollectionBulkInput | 

try {
    final response = api.updateCollection(collectionBulkInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CollectionApi->updateCollection: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **collectionBulkInput** | [**CollectionBulkInput**](CollectionBulkInput.md)|  | 

### Return type

[**BuiltList&lt;CollectionItem&gt;**](CollectionItem.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateCollectionItem**
> CollectionItem updateCollectionItem(profileId, collectionItemInput)

Set the counts for one profile

Send just the count that moved and the other two settle around it. The three nest as `painted <= built <= owned`, so raising a narrower count pulls the wider ones up with it, and lowering a wider one pushes the narrower ones down. The values are absolute, never increments, so replaying a request the client never saw the answer to is a no-op. Setting every count to zero drops the profile from the collection; the response still reports the resulting zeros so the client can reconcile without a second request. 

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

final api = CarnevaleApi().getCollectionApi();
final int profileId = 56; // int | 
final CollectionItemInput collectionItemInput = ; // CollectionItemInput | 

try {
    final response = api.updateCollectionItem(profileId, collectionItemInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CollectionApi->updateCollectionItem: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **profileId** | **int**|  | 
 **collectionItemInput** | [**CollectionItemInput**](CollectionItemInput.md)|  | 

### Return type

[**CollectionItem**](CollectionItem.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

