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

import 'package:built_value/serializer.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:dio/dio.dart';
import 'api_client.dart';
import 'api_exception.dart';
import 'catalog_cache.dart';

class EquipmentService {
  static final EquipmentService _instance = EquipmentService._();
  factory EquipmentService() => _instance;
  EquipmentService._();

  final _client = ApiClient();
  List<api.Equipment>? _cache;

  static const _cacheKey = 'catalog_equipment';

  Future<List<api.Equipment>> getAll() async {
    // Equipment changes only between releases, like the rest of the catalog, so cache it for the
    // session instead of refetching on every gang-builder open.
    if (_cache != null) return _cache!;
    try {
      final res = await _client.equipment.getEquipment();
      final equipment = res.data?.toList() ?? [];
      _cache = equipment;
      await CatalogCache.save(_cacheKey, equipment, const FullType(api.Equipment));
      return equipment;
    } on DioException catch (e) {
      final restored = await CatalogCache.restore<api.Equipment>(
        _cacheKey,
        const FullType(api.Equipment),
      );
      if (restored != null) {
        _cache = restored;
        return restored;
      }
      throw ApiException.from(e);
    }
  }

  /// Drops the cached equipment so the next [getAll] refetches (S-3).
  void reset() => _cache = null;
}
