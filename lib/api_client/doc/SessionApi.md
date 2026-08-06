# carnevale_api.api.SessionApi

## Load the API package
```dart
import 'package:carnevale_api/api.dart';
```

All URIs are relative to *http://localhost:3000/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**createCableTicket**](SessionApi.md#createcableticket) | **POST** /cable_tickets | Mint a short-lived, single-use ticket for opening the ActionCable WebSocket
[**forgotPassword**](SessionApi.md#forgotpassword) | **POST** /password | Request a password reset email
[**login**](SessionApi.md#login) | **POST** /login | Log in and receive a JWT
[**logout**](SessionApi.md#logout) | **DELETE** /logout | Sign out this device
[**logoutAll**](SessionApi.md#logoutall) | **DELETE** /logout_all | Sign out every device
[**refreshToken**](SessionApi.md#refreshtoken) | **POST** /token | Exchange a refresh token for a fresh JWT
[**resetPassword**](SessionApi.md#resetpassword) | **PATCH** /password | Set a new password using a reset token
[**signup**](SessionApi.md#signup) | **POST** /signup | Register a new user
[**updateAccount**](SessionApi.md#updateaccount) | **PATCH** /account | Update the current user&#39;s username


# **createCableTicket**
> CreateCableTicket201Response createCableTicket()

Mint a short-lived, single-use ticket for opening the ActionCable WebSocket

Returns a one-time ticket to pass as the `ticket` query parameter when connecting to `/cable`, so the reusable JWT never travels in the (loggable) WebSocket URL. The ticket expires within seconds and is consumed the first time it is redeemed. 

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

final api = CarnevaleApi().getSessionApi();

try {
    final response = api.createCableTicket();
    print(response);
} on DioException catch (e) {
    print('Exception when calling SessionApi->createCableTicket: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**CreateCableTicket201Response**](CreateCableTicket201Response.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **forgotPassword**
> forgotPassword(forgotPasswordInput)

Request a password reset email

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

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

[ApiKeyAuth](../README.md#ApiKeyAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **login**
> Session login(loginInput)

Log in and receive a JWT

On success, a short-lived JWT is returned in the `Authorization` response header as `Bearer <token>` (send it back on subsequent requests to authenticate), and a long-lived `refresh_token` is returned in the body for renewing the JWT via POST /token once it expires. 

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

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

[ApiKeyAuth](../README.md#ApiKeyAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **logout**
> logout(logoutRequest)

Sign out this device

Denylists the current JWT and revokes the refresh token supplied in the body — this device only. Other devices keep their sessions. Clients should always send `refresh_token`; when it is omitted the endpoint falls back to revoking every refresh token the user holds, which is the pre-existing behaviour retained for older builds that cannot name their token. To sign out everywhere on purpose, use `/logout_all`. 

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

final api = CarnevaleApi().getSessionApi();
final LogoutRequest logoutRequest = ; // LogoutRequest | 

try {
    api.logout(logoutRequest);
} on DioException catch (e) {
    print('Exception when calling SessionApi->logout: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **logoutRequest** | [**LogoutRequest**](LogoutRequest.md)|  | [optional] 

### Return type

void (empty response body)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **logoutAll**
> logoutAll()

Sign out every device

Denylists the current JWT and revokes every refresh token the user holds. Other devices lose the ability to renew immediately, but their existing access JWTs remain valid until they expire (at most one hour), after which the refresh they attempt fails. 

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

final api = CarnevaleApi().getSessionApi();

try {
    api.logoutAll();
} on DioException catch (e) {
    print('Exception when calling SessionApi->logoutAll: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **refreshToken**
> Session refreshToken(refreshInput)

Exchange a refresh token for a fresh JWT

Trades a valid refresh token for a new short-lived JWT (returned in the `Authorization` response header) and a rotated `refresh_token` (returned in the body). Does NOT require a live JWT — this is how a client renews once its JWT has expired. The presented refresh token is invalidated; use the one returned here for the next refresh. 

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

final api = CarnevaleApi().getSessionApi();
final RefreshInput refreshInput = ; // RefreshInput | 

try {
    final response = api.refreshToken(refreshInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SessionApi->refreshToken: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **refreshInput** | [**RefreshInput**](RefreshInput.md)|  | 

### Return type

[**Session**](Session.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **resetPassword**
> Session resetPassword(resetPasswordInput)

Set a new password using a reset token

Completing a reset signs the user in: the caller proved control of the account's inbox and has just chosen the password, so a short-lived JWT is returned in the `Authorization` response header and a long-lived `refresh_token` in the body, exactly as POST /login does. The reset token is single-use — replaying it answers 422. 

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

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

[ApiKeyAuth](../README.md#ApiKeyAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **signup**
> Account signup(registrationInput)

Register a new user

Creates the account and returns it. Registering does **not** sign the new user in: no JWT is issued and no `refresh_token` is returned, so the client follows this with POST /login to obtain a session.  This used to be documented as returning a `Session`, which the controller never did (CARNEVALEB-73). The generated client took the document at its word and failed to deserialize every *successful* registration — reporting the account creation as an error while the account was in fact created. 

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

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

[**Account**](Account.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateAccount**
> Account updateAccount(updateAccountInput)

Update the current user's username

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

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

[**Account**](Account.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

