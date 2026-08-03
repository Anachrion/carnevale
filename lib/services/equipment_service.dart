// Carnevale Companion
// Copyright (C) 2026 Anachrion and contributors
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU Affero General Public License as published by the Free
// Software Foundation, either version 3 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
// details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

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
