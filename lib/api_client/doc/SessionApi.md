# carnevale_api.api.SessionApi

## Load the API package
```dart
import 'package:carnevale_api/api.dart';
```

All URIs are relative to *http://localhost:3000/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**forgotPassword**](SessionApi.md#forgotpassword) | **POST** /password | Request a password reset email
[**login**](SessionApi.md#login) | **POST** /login | Log in and receive a JWT
[**logout**](SessionApi.md#logout) | **DELETE** /logout | Revoke the current JWT
[**resetPassword**](SessionApi.md#resetpassword) | **PATCH** /password | Set a new password using a reset token
[**signup**](SessionApi.md#signup) | **POST** /signup | Register a new user
[**updateAccount**](SessionApi.md#updateaccount) | **PATCH** /account | Update the current user&#39;s username


# **forgotPassword**
> forgotPassword(forgotPasswordInput)

Request a password reset email

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getSessionApi();
final ForgotPasswordInput forgotPasswordInput = ; // ForgotPasswordInput | 

try {
    api.forgotPassword(forgotPasswordInput);
} on DioException catch (e) {
    print('Exception when calling SessionApi->forgotPassword: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **forgotPasswordInput** | [**ForgotPasswordInput**](ForgotPasswordInput.md)|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

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

# **resetPassword**
> Session resetPassword(resetPasswordInput)

Set a new password using a reset token

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getSessionApi();
final ResetPasswordInput resetPasswordInput = ; // ResetPasswordInput | 

try {
    final response = api.resetPassword(resetPasswordInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SessionApi->resetPassword: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **resetPasswordInput** | [**ResetPasswordInput**](ResetPasswordInput.md)|  | 

### Return type

[**Session**](Session.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **signup**
> Session signup(registrationInput)

Register a new user

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

# **updateAccount**
> Session updateAccount(updateAccountInput)

Update the current user's username

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getSessionApi();
final UpdateAccountInput updateAccountInput = ; // UpdateAccountInput | 

try {
    final response = api.updateAccount(updateAccountInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SessionApi->updateAccount: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **updateAccountInput** | [**UpdateAccountInput**](UpdateAccountInput.md)|  | 

### Return type

[**Session**](Session.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

