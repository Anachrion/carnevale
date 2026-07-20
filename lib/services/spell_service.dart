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

/// The full spell catalog. Like the rest of the catalog (equipment, abilities, profiles) it only
/// changes between releases, so it's fetched once per session and cached — the gang builder and the
/// in-game spell views both read it, and neither should re-hit `/spells` every time they open.
class SpellService {
  static final SpellService _instance = SpellService._();
  factory SpellService() => _instance;
  SpellService._();

  final _client = ApiClient();
  List<api.Spell>? _cache;

  static const _cacheKey = 'catalog_spells';

  Future<List<api.Spell>> getAll() async {
    if (_cache != null) return _cache!;
    try {
      final res = await _client.spells.getSpells();
      final spells = res.data?.toList() ?? [];
      _cache = spells;
      await CatalogCache.save(_cacheKey, spells, const FullType(api.Spell));
      return spells;
    } on DioException catch (e) {
      final restored = await CatalogCache.restore<api.Spell>(
        _cacheKey,
        const FullType(api.Spell),
      );
      if (restored != null) {
        _cache = restored;
        return restored;
      }
      throw ApiException.from(e);
    }
  }

  /// Drops the cached spells so the next [getAll] refetches (catalog refresh).
  void reset() => _cache = null;
}
