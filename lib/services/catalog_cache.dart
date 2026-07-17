// Copyright 2026 Anachrion
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists a catalog collection to shared_preferences and restores it, so the app can show the
/// last-good catalog on a fully offline start instead of an error (C-6). Serializes through the
/// generated built_value serializers, so the on-disk form is exactly the API's wire format and a
/// restored value is indistinguishable from a freshly fetched one.
class CatalogCache {
  const CatalogCache._();

  static Future<void> save<T>(String key, Iterable<T> items, FullType itemType) async {
    try {
      final data = api.standardSerializers.serialize(
        BuiltList<T>(items),
        specifiedType: FullType(BuiltList, [itemType]),
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, jsonEncode(data));
    } catch (e) {
      debugPrint('Catalog cache save ($key) failed: $e');
    }
  }

  static Future<List<T>?> restore<T>(String key, FullType itemType) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(key);
      if (raw == null) return null;
      final decoded = api.standardSerializers.deserialize(
        jsonDecode(raw),
        specifiedType: FullType(BuiltList, [itemType]),
      );
      return (decoded as BuiltList<T>).toList();
    } catch (e) {
      debugPrint('Catalog cache restore ($key) failed: $e');
      return null;
    }
  }
}
