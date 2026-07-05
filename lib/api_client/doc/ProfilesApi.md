# carnevale_api.api.ProfilesApi

## Load the API package
```dart
import 'package:carnevale_api/api.dart';
```

All URIs are relative to *http://localhost:3000/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getProfile**](ProfilesApi.md#getprofile) | **GET** /profiles/{id} | Get a profile
[**getProfiles**](ProfilesApi.md#getprofiles) | **GET** /profiles | List all profiles


# **getProfile**
> Profile getProfile(id)

Get a profile

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

final api = CarnevaleApi().getProfilesApi();
final int id = 56; // int | 

try {
    final response = api.getProfile(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProfilesApi->getProfile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 

### Return type

[**Profile**](Profile.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getProfiles**
> BuiltList<Profile> getProfiles(faction)

List all profiles

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

final api = CarnevaleApi().getProfilesApi();
final String faction = faction_example; // String | 

try {
    final response = api.getProfiles(faction);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ProfilesApi->getProfiles: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **faction** | **String**|  | [optional] 

### Return type

[**BuiltList&lt;Profile&gt;**](Profile.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

