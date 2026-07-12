# carnevale_api.api.CardsApi

## Load the API package
```dart
import 'package:carnevale_api/api.dart';
```

All URIs are relative to *http://localhost:3000/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getCardsManifest**](CardsApi.md#getcardsmanifest) | **GET** /cards/manifest | Card image sync manifest (identifier, internal_version, download URLs)


# **getCardsManifest**
> GetCardsManifest200Response getCardsManifest(faction)

Card image sync manifest (identifier, internal_version, download URLs)

One entry per card with its current internal_version and the versioned URLs to download its front/back images. Clients cache images locally and re-download only cards whose internal_version is higher than the cached one. Card stats come from /profiles. 

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

final api = CarnevaleApi().getCardsApi();
final String faction = faction_example; // String | 

try {
    final response = api.getCardsManifest(faction);
    print(response);
} on DioException catch (e) {
    print('Exception when calling CardsApi->getCardsManifest: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **faction** | **String**|  | [optional] 

### Return type

[**GetCardsManifest200Response**](GetCardsManifest200Response.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

