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
[**setListEntryIllustration**](ListEntriesApi.md#setlistentryillustration) | **PATCH** /list_entries/{id}/illustration | Switch which illustration (card reference) a model is hired as
[**setListEntrySpells**](ListEntriesApi.md#setlistentryspells) | **PATCH** /list_entries/{id}/spells | Set the spells (and Discipline(s)) a Mage model knows, per pool
[**setListEntryUpgrade**](ListEntriesApi.md#setlistentryupgrade) | **PATCH** /list_entries/{id}/upgrade | Toggle a model&#39;s optional paid companion upgrade
[**updateListEntryPosition**](ListEntriesApi.md#updatelistentryposition) | **PATCH** /list_entries/{id} | Move a card to a new position in the list


# **createListEntry**
> BuiltList createListEntry(entryInput, idempotencyKey)

Add a card to a list

Returns 404 if the list doesn't belong to the current user.

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

final api = CarnevaleApi().getListEntriesApi();
final EntryInput entryInput = ; // EntryInput | 
final String idempotencyKey = idempotencyKey_example; // String | Optional client-generated opaque token that makes this additive create idempotent: a request re-sent after a lost response (e.g. the app's optimistic sync queue retrying a timed-out hire) replays the original result instead of creating a duplicate. Mint one token per logical action and reuse it across that action's retries. Bounded to `[A-Za-z0-9._-]{16,128}`; a value outside that is ignored (the create proceeds non-idempotently). 

try {
    final response = api.createListEntry(entryInput, idempotencyKey);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ListEntriesApi->createListEntry: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **entryInput** | [**EntryInput**](EntryInput.md)|  | 
 **idempotencyKey** | **String**| Optional client-generated opaque token that makes this additive create idempotent: a request re-sent after a lost response (e.g. the app's optimistic sync queue retrying a timed-out hire) replays the original result instead of creating a duplicate. Mint one token per logical action and reuse it across that action's retries. Bounded to `[A-Za-z0-9._-]{16,128}`; a value outside that is ignored (the create proceeds non-idempotently).  | [optional] 

### Return type

[**BuiltList**](BuiltList.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

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
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

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

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **setListEntryIllustration**
> BuiltList setListEntryIllustration(id, entryIllustrationInput)

Switch which illustration (card reference) a model is hired as

Repoints a hired model at a different card reference of the same profile — swapping the illustration without changing who the model is or its cost. Rejected with 422 if the target reference belongs to a different profile, or if the entry has no card (Equipment). Returns 404 if the entry's list doesn't belong to the current user. 

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

final api = CarnevaleApi().getListEntriesApi();
final int id = 56; // int | 
final EntryIllustrationInput entryIllustrationInput = ; // EntryIllustrationInput | 

try {
    final response = api.setListEntryIllustration(id, entryIllustrationInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ListEntriesApi->setListEntryIllustration: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **entryIllustrationInput** | [**EntryIllustrationInput**](EntryIllustrationInput.md)|  | 

### Return type

[**BuiltList**](BuiltList.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **setListEntrySpells**
> BuiltList setListEntrySpells(id, setEntrySpellsInput)

Set the spells (and Discipline(s)) a Mage model knows, per pool

Replaces the model's committed Discipline(s) and known spells, one pool at a time (rulebook p24, generalized for CARNEVALEB-47's exceptions — most models have exactly one pool). Only Mage models may know spells; an illegal selection still saves, but the returned list will report selection_valid: false with the reason. Also reachable for a model in an active game's roster (not just the reusable gang list) up until that game's owning player has confirmed their Agendas, at which point it 422s — spells lock in together with Agendas at the start of the game. Returns 404 if the entry's list doesn't belong to the current user. 

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

final api = CarnevaleApi().getListEntriesApi();
final int id = 56; // int | 
final SetEntrySpellsInput setEntrySpellsInput = ; // SetEntrySpellsInput | 

try {
    final response = api.setListEntrySpells(id, setEntrySpellsInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ListEntriesApi->setListEntrySpells: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **setEntrySpellsInput** | [**SetEntrySpellsInput**](SetEntrySpellsInput.md)|  | 

### Return type

[**BuiltList**](BuiltList.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **setListEntryUpgrade**
> BuiltList setListEntryUpgrade(id, entryUpgradeInput)

Toggle a model's optional paid companion upgrade

Buys or drops a model's optional paid upgrade — the Emissary of Mother Hydra's +12 Ducats for a second set of Tentacles (8 instead of 4) — and reconciles its auto-included companion entries to match. The upgrade's Ducat cost is added to the entry's cost. Returns 404 if the entry's list doesn't belong to the current user. 

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

final api = CarnevaleApi().getListEntriesApi();
final int id = 56; // int | 
final EntryUpgradeInput entryUpgradeInput = ; // EntryUpgradeInput | 

try {
    final response = api.setListEntryUpgrade(id, entryUpgradeInput);
    print(response);
} on DioException catch (e) {
    print('Exception when calling ListEntriesApi->setListEntryUpgrade: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **int**|  | 
 **entryUpgradeInput** | [**EntryUpgradeInput**](EntryUpgradeInput.md)|  | 

### Return type

[**BuiltList**](BuiltList.md)

### Authorization

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateListEntryPosition**
> BuiltList updateListEntryPosition(id, entryPositionInput)

Move a card to a new position in the list

Returns 404 if the entry's list doesn't belong to the current user.

### Example
```dart
import 'package:carnevale_api/api.dart';
// TODO Configure API key authorization: ApiKeyAuth
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('ApiKeyAuth').apiKeyPrefix = 'Bearer';

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

[ApiKeyAuth](../README.md#ApiKeyAuth), [bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

