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
