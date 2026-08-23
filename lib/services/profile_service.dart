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
import '../models/profile_query.dart';
import 'ability_service.dart';
import 'api_client.dart';
import 'api_exception.dart';
import 'catalog_cache.dart';

/// The searchable projection of one profile, built once when the catalog is cached: the base facets
/// it carries, and a lowercased blob of every string free text sweeps. Precomputed because the
/// screen re-queries on every keystroke, and re-parsing every profile's ability strings each time
/// is the one thing that would make a local search feel slow.
class _ProfileIndex {
  const _ProfileIndex({required this.facets, required this.haystack});

  final Set<Facet> facets;
  final String haystack;
}

/// The profile catalog, fetched once and searched entirely on the device.
///
/// The catalog is ~312 profiles and only changes between releases, so it is cached in full and
/// every query — text, facets, factions — runs locally against [_index]. That keeps search instant
/// and working offline; the API deliberately has no search endpoint.
class ProfileService {
  static final ProfileService _instance = ProfileService._();
  factory ProfileService() => _instance;
  ProfileService._();

  final _client = ApiClient();
  List<api.Profile>? _cache;

  /// Profile id -> its precomputed searchable projection.
  final Map<int, _ProfileIndex> _index = {};

  /// Every facet in the catalog, with the number of profiles carrying it. This is the autocomplete
  /// vocabulary: it is derived from the profiles themselves, so it can never offer a filter that
  /// matches nothing.
  final Map<Facet, int> _vocabulary = {};

  static const _cacheKey = 'catalog_profiles';

  Future<List<api.Profile>> loadAll() async {
    if (_cache != null) return _cache!;
    try {
      final res = await _client.profiles.getProfiles();
      final profiles = (res.data?.toList() ?? [])
        ..sort((a, b) => a.name.compareTo(b.name));
      _reindex(profiles);
      _cache = profiles;
      // Persist the last-good catalog so a later offline launch can still browse cards (C-6).
      await CatalogCache.save(_cacheKey, profiles, const FullType(api.Profile));
      return profiles;
    } on DioException catch (e) {
      // Offline / server down: fall back to the last-good catalog on disk rather than failing.
      final restored = await CatalogCache.restore<api.Profile>(
        _cacheKey,
        const FullType(api.Profile),
      );
      if (restored != null) {
        _reindex(restored);
        _cache = restored;
        return restored;
      }
      throw ApiException.from(e);
    }
  }

  /// Drops the in-memory catalog so the next [loadAll] refetches. Called when the user re-syncs
  /// card data, so freshly published stats/illustrations show without an app restart (S-3).
  void reset() {
    _cache = null;
    _index.clear();
    _vocabulary.clear();
  }

  /// Profiles matching [query], in catalog order. Synchronous, so a caller that has already awaited
  /// [loadAll] can run it straight from a keystroke; empty until the catalog has loaded.
  List<api.Profile> matching(ProfileQuery query) {
    final all = _cache;
    if (all == null) return const [];

    final terms = query.text
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .where((term) => term.isNotEmpty);

    return all.where((profile) {
      if (query.factions.isNotEmpty &&
          !query.factions.contains(profile.faction)) {
        return false;
      }
      // Cheapest discriminator when the collection filter is on, so it goes before the index
      // lookup and the text sweep.
      if (query.ownedIds != null && !query.ownedIds!.contains(profile.id)) {
        return false;
      }
      final index = _index[profile.id];
      if (index == null) return false;
      // Every picked facet must be present: two ability facets mean "has both".
      if (!query.facets.every(index.facets.contains)) return false;
      // Each word must land somewhere, so "brave leader" narrows instead of finding nothing.
      return terms.every(index.haystack.contains);
    }).toList();
  }

  /// Facets whose name contains [text], best first, to autocomplete the search box. Prefix matches
  /// lead, then the most common facets, so typing "bra" offers Brave and Brawler before Expert
  /// Grappler. Facets the user already picked are passed in [exclude] so they aren't offered twice.
  List<FacetSuggestion> suggest(
    String text, {
    Set<Facet> exclude = const {},
    int limit = 6,
  }) {
    final query = text.trim().toLowerCase();
    if (query.isEmpty) return const [];

    final hits = <FacetSuggestion>[];
    _vocabulary.forEach((facet, count) {
      if (exclude.contains(facet)) return;
      if (!facet.name.toLowerCase().contains(query)) return;
      hits.add(FacetSuggestion(facet: facet, count: count));
    });

    hits.sort((a, b) {
      final aPrefix = a.facet.name.toLowerCase().startsWith(query) ? 0 : 1;
      final bPrefix = b.facet.name.toLowerCase().startsWith(query) ? 0 : 1;
      if (aPrefix != bPrefix) return aPrefix - bPrefix;
      if (a.count != b.count) return b.count - a.count;
      return a.facet.name.compareTo(b.facet.name);
    });
    return hits.take(limit).toList();
  }

  Future<List<api.Profile>> search(
    String query, {
    Set<String>? factions,
    Set<Facet>? facets,
  }) async {
    await loadAll();
    return matching(
      ProfileQuery(
        text: query,
        factions: factions ?? const {},
        facets: facets ?? const {},
      ),
    );
  }

  Future<List<String>> factions() async {
    final all = await loadAll();
    return all.map((p) => p.faction).toSet().toList()..sort();
  }

  void _reindex(List<api.Profile> profiles) {
    _index.clear();
    _vocabulary.clear();

    for (final profile in profiles) {
      final facets = <Facet>{};
      final haystack = StringBuffer()
        ..writeln(profile.name)
        ..writeln(profile.faction);

      // Abilities and keywords arrive with any rating baked into the string ("Acrobatic (2)",
      // "Discipline (Blood Rites, Divinity)"). The facet is the base name, so one filter covers
      // every rating of it; the full string still goes into the haystack, so free text can reach
      // the rating too.
      for (final keyword in profile.keywords) {
        haystack.writeln(keyword);
        facets.add(Facet(FacetKind.keyword, AbilityService.baseName(keyword)));
      }
      for (final ability in profile.abilities) {
        haystack.writeln(ability);
        facets.add(Facet(FacetKind.ability, AbilityService.baseName(ability)));
      }
      for (final weapon in profile.weapons) {
        haystack.writeln(weapon.name);
        for (final ability in weapon.abilities) {
          haystack.writeln(ability);
          facets.add(
            Facet(FacetKind.weaponAbility, AbilityService.baseName(ability)),
          );
        }
      }
      // Special rules are model-specific — 339 of them across 312 profiles — so they are free text
      // only, never a facet. Their spell fields go in too, so a rule that grants a spell is findable
      // by the spell's name.
      for (final rule in profile.specialRules) {
        haystack
          ..writeln(rule.name)
          ..writeln(rule.description)
          ..writeln(rule.spellName ?? '')
          ..writeln(rule.spellDescription ?? '');
      }

      _index[profile.id] = _ProfileIndex(
        facets: facets,
        haystack: haystack.toString().toLowerCase(),
      );
      for (final facet in facets) {
        _vocabulary[facet] = (_vocabulary[facet] ?? 0) + 1;
      }
    }
  }
}
