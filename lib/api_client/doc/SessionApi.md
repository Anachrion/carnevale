# carnevale_api.api.SessionApi

## Load the API package
```dart
import 'package:carnevale_api/api.dart';
```

All URIs are relative to *http://localhost:3000/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**login**](SessionApi.md#login) | **POST** /login | Log in and receive a JWT
[**logout**](SessionApi.md#logout) | **DELETE** /logout | Revoke the current JWT
[**signup**](SessionApi.md#signup) | **POST** /signup | Register a new user


# **login**
> Session login(loginInput)

Log in and receive a JWT

On success, the JWT is returned in the `Authorization` response header as `Bearer <token>`. Send it back on subsequent requests to authenticate.

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getSessionApi();
final LoginInput loginInput = ; // LoginInput | 

try {
    final response = api.login(loginInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SessionApi->login: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **loginInput** | [**LoginInput**](LoginInput.md)|  | 

### Return type

[**Session**](Session.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **logout**
> logout()

Revoke the current JWT

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getSessionApi();

try {
    api.logout();
} on DioException catch (e) {
    print('Exception when calling SessionApi->logout: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **signup**
> Session signup(registrationInput)

Register a new user

Creates the user and sends a confirmation email. The user cannot log in until the confirmation link has been clicked.

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getSessionApi();
final RegistrationInput registrationInput = ; // RegistrationInput | 

try {
    final response = api.signup(registrationInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SessionApi->signup: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **registrationInput** | [**RegistrationInput**](RegistrationInput.md)|  | 

### Return type

[**Session**](Session.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

