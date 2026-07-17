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

/// A glossary ability (character or weapon special rule) resolved against a profile, pairing the
/// label as printed on the card (e.g. "Acrobatic (2)") with its rulebook description.
class ResolvedAbility {
  const ResolvedAbility({required this.label, required this.description});

  /// The ability as it appears on the profile/weapon, including any "(X)" rating.
  final String label;

  /// The rulebook description, or null if the ability isn't in the glossary.
  final String? description;
}

/// Loads and caches the glossary of generic Character and Weapon abilities (rulebook p44-48) and
/// resolves a profile's ability strings — which carry an "(X)" rating, e.g. "Reload (2)" — against
/// it by matching on the base name.
class AbilityService {
  static final AbilityService _instance = AbilityService._();
  factory AbilityService() => _instance;
  AbilityService._();

  final _client = ApiClient();

  // Base name -> description, split by category. Populated on first [load].
  final Map<String, String> _character = {};
  final Map<String, String> _weapon = {};
  bool _loaded = false;

  static final _ratingSuffix = RegExp(r'\s*\(.*\)$');

  /// Strips the "(X)" rating from an ability string, e.g. "Acrobatic (2)" -> "Acrobatic".
  static String baseName(String ability) => ability.replaceAll(_ratingSuffix, '').trim();

  static const _cacheKey = 'catalog_abilities';

  Future<void> load() async {
    if (_loaded) return;
    try {
      final res = await _client.abilities.getAbilities();
      final abilities = res.data?.toList() ?? const <api.Ability>[];
      _index(abilities);
      _loaded = true;
      await CatalogCache.save(_cacheKey, abilities, const FullType(api.Ability));
    } on DioException catch (e) {
      // Offline: fall back to the last-good glossary so card abilities still resolve (C-6).
      final restored = await CatalogCache.restore<api.Ability>(
        _cacheKey,
        const FullType(api.Ability),
      );
      if (restored != null) {
        _index(restored);
        _loaded = true;
        return;
      }
      throw ApiException.from(e);
    }
  }

  void _index(Iterable<api.Ability> abilities) {
    _character.clear();
    _weapon.clear();
    for (final a in abilities) {
      final glossary =
          a.category == api.AbilityCategoryEnum.weapon ? _weapon : _character;
      glossary[a.name] = a.description;
    }
  }

  /// Drops the cached glossary so the next [load] refetches (S-3).
  void reset() {
    _loaded = false;
    _character.clear();
    _weapon.clear();
  }

  List<ResolvedAbility> _resolve(Iterable<String> labels, Map<String, String> glossary) => labels
      .map((l) => ResolvedAbility(label: l, description: glossary[baseName(l)]))
      .toList();

  /// Resolved character abilities for [profile], in card order.
  List<ResolvedAbility> characterAbilities(api.Profile profile) =>
      _resolve(profile.abilities, _character);

  /// Resolved weapon abilities across all of [profile]'s weapons, de-duplicated by label and kept
  /// in first-seen order.
  List<ResolvedAbility> weaponAbilities(api.Profile profile) {
    final seen = <String>{};
    final labels = <String>[];
    for (final w in profile.weapons) {
      for (final ability in w.abilities) {
        if (seen.add(ability)) labels.add(ability);
      }
    }
    return _resolve(labels, _weapon);
  }
}
