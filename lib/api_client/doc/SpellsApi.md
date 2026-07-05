# carnevale_api.api.SpellsApi

## Load the API package
```dart
import 'package:carnevale_api/api.dart';
```

All URIs are relative to *http://localhost:3000/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getSpells**](SpellsApi.md#getspells) | **GET** /spells | List all spells, optionally filtered by Discipline


# **getSpells**
> BuiltList<Spell> getSpells(discipline)

List all spells, optionally filtered by Discipline

### Example
```dart
import 'package:carnevale_api/api.dart';

final api = CarnevaleApi().getSpellsApi();
final String discipline = discipline_example; // String | 

try {
    final response = api.getSpells(discipline);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SpellsApi->getSpells: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **discipline** | **String**|  | [optional] 

### Return type

[**BuiltList&lt;Spell&gt;**](Spell.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

