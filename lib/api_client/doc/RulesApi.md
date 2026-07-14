# carnevale_api.api.RulesApi

## Load the API package
```dart
import 'package:carnevale_api/api.dart';
```

All URIs are relative to *http://localhost:3000/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getRulesDocuments**](RulesApi.md#getrulesdocuments) | **GET** /rules_documents | List the rules PDFs the app&#39;s Rules page offers, in display order


# **getRulesDocuments**
> BuiltList<RulesDocument> getRulesDocuments()

List the rules PDFs the app's Rules page offers, in display order

Links to TT Combat's own published PDFs. The URLs carry a Shopify `?v=` cache buster that changes whenever a document is re-uploaded, so a client that caches a file should re-download it when the URL for a `key` differs from the one it cached. 

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

final api = CarnevaleApi().getRulesApi();

try {
    final response = api.getRulesDocuments();
    print(response);
} on DioException catch (e) {
    print('Exception when calling RulesApi->getRulesDocuments: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**BuiltList&lt;RulesDocument&gt;**](RulesDocument.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

