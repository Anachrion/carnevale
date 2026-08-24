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

import 'dart:async';

import 'package:built_value/serializer.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_client.dart';
import 'api_exception.dart';
import 'catalog_cache.dart';

/// How many miniatures of one profile the player has, and how far along they are.
///
/// The three counts nest — `painted <= built <= owned` — exactly as the server stores them. The
/// screens mostly want the *exclusive* buckets instead ("1 painted, 2 built, 1 still boxed"), so
/// those are derived here rather than recomputed at each call site.
@immutable
class CollectionEntry {
  const CollectionEntry({this.owned = 0, this.built = 0, this.painted = 0});

  factory CollectionEntry.from(api.CollectionItem item) => CollectionEntry(
    owned: item.owned,
    built: item.built,
    painted: item.painted,
  );

  final int owned;
  final int built;
  final int painted;

  static const none = CollectionEntry();

  bool get isEmpty => owned == 0;

  /// Owned but not yet assembled.
  int get boxed => owned - built;

  /// Assembled but not yet painted.
  int get unpainted => built - painted;

  /// This entry with one count moved, pulled back into `painted <= built <= owned`.
  ///
  /// Mirrors `Collection::Item#normalize_counts` on the server, deliberately: the steppers write
  /// optimistically, and showing the raw edit first (1 painted of 0 built) then snapping to the
  /// server's answer would flicker through a state that cannot exist. The rule is directional —
  /// raising a narrower count pulls the wider ones up, lowering a wider one pushes the narrower
  /// ones down — so a single tap does the obvious thing whichever direction it goes.
  CollectionEntry withCount(CollectionCount count, int value) {
    final target = value < 0 ? 0 : value;
    var next = switch (count) {
      CollectionCount.owned => CollectionEntry(
        owned: target,
        built: built,
        painted: painted,
      ),
      CollectionCount.built => CollectionEntry(
        owned: owned,
        built: target,
        painted: painted,
      ),
      CollectionCount.painted => CollectionEntry(
        owned: owned,
        built: built,
        painted: target,
      ),
    };
    final raised = target > valueOf(count);

    if (next.painted > next.built) {
      next = raised && count == CollectionCount.painted
          ? CollectionEntry(
              owned: next.owned,
              built: next.painted,
              painted: next.painted,
            )
          : CollectionEntry(
              owned: next.owned,
              built: next.built,
              painted: next.built,
            );
    }
    if (next.built > next.owned) {
      next = raised && count != CollectionCount.owned
          ? CollectionEntry(
              owned: next.built,
              built: next.built,
              painted: next.painted,
            )
          : CollectionEntry(
              owned: next.owned,
              built: next.owned,
              painted: next.painted,
            );
    }
    // `built` may itself have just been pushed down to `owned`, taking it back under `painted`.
    return next.painted > next.built
        ? CollectionEntry(
            owned: next.owned,
            built: next.built,
            painted: next.built,
          )
        : next;
  }

  int valueOf(CollectionCount count) => switch (count) {
    CollectionCount.owned => owned,
    CollectionCount.built => built,
    CollectionCount.painted => painted,
  };

  @override
  bool operator ==(Object other) =>
      other is CollectionEntry &&
      other.owned == owned &&
      other.built == built &&
      other.painted == painted;

  @override
  int get hashCode => Object.hash(owned, built, painted);

  @override
  String toString() => 'CollectionEntry($owned/$built/$painted)';
}

/// The three counts, from widest to narrowest.
enum CollectionCount { owned, built, painted }

/// The player's collection of miniatures: which models they own, and how far along each one is.
///
/// Server-side per user, so it follows the player between devices, with the last-loaded copy
/// persisted through [CatalogCache] — that keeps the badges and the "my collection" filter working
/// on a cold offline start, read-only, the same way the catalog itself does. Logged out there is no
/// collection at all and every screen behaves exactly as it did before the feature existed.
class CollectionService extends ChangeNotifier {
  // Factory singleton, matching the other services, so `CollectionService()` anywhere resolves to
  // the instance the screens are listening to rather than a second, listener-less copy.
  static final CollectionService _instance = CollectionService._();
  factory CollectionService() => _instance;
  CollectionService._();

  final _client = ApiClient();

  static const _cacheKey = 'collection_items';

  /// Profile id -> counts. Null until [load] has run; empty once loaded for a player who owns
  /// nothing. Only non-empty entries are held, mirroring the server, so `containsKey` *is*
  /// "owns at least one".
  Map<int, CollectionEntry>? _items;

  bool get isLoaded => _items != null;

  /// The ids the "my collection" filter narrows to. Empty (not null) before loading, so a screen
  /// that filters before the collection arrives shows nothing rather than everything — the honest
  /// answer while we don't know yet.
  Set<int> get ownedProfileIds => _items?.keys.toSet() ?? const {};

  CollectionEntry entryFor(int profileId) =>
      _items?[profileId] ?? CollectionEntry.none;

  bool owns(int profileId) => _items?.containsKey(profileId) ?? false;

  int get ownedProfileCount => _items?.length ?? 0;

  /// Totals across the whole collection.
  ({int owned, int built, int painted}) get totals =>
      totalsFor(_items?.keys ?? const <int>[]);

  /// Totals across [profileIds] only — what the progress panel reads once a faction is picked,
  /// since "have I finished the Guild?" is a question people actually ask and "have I collected
  /// all 316 models?" is not.
  ({int owned, int built, int painted}) totalsFor(Iterable<int> profileIds) {
    var owned = 0, built = 0, painted = 0;
    for (final id in profileIds) {
      final entry = _items?[id];
      if (entry == null) continue;
      owned += entry.owned;
      built += entry.built;
      painted += entry.painted;
    }
    return (owned: owned, built: built, painted: painted);
  }

  Future<void> load({bool force = false}) async {
    if (_items != null && !force) return;
    try {
      final res = await _client.collection.getCollection();
      _items = {
        for (final item in res.data ?? const <api.CollectionItem>[])
          item.profileId: CollectionEntry.from(item),
      };
      notifyListeners();
      await CatalogCache.save(
        _cacheKey,
        res.data ?? const <api.CollectionItem>[],
        const FullType(api.CollectionItem),
      );
    } on DioException catch (e) {
      // Offline: fall back to the last-loaded copy so the badges and the filter still work.
      final restored = await CatalogCache.restore<api.CollectionItem>(
        _cacheKey,
        const FullType(api.CollectionItem),
      );
      if (restored == null) throw ApiException.from(e);
      _items = {
        for (final item in restored) item.profileId: CollectionEntry.from(item),
      };
      notifyListeners();
    }
  }

  /// Moves one count for one profile, optimistically.
  ///
  /// The new state is shown at once and the write follows; a failure puts the previous entry back
  /// and reports false so the caller can say so. The request carries the whole settled entry rather
  /// than the single count the user touched: the server would reach the same result from either,
  /// but sending what we already decided to display keeps the two from disagreeing if the
  /// normalisation rules ever drift apart.
  Future<bool> setCount(int profileId, CollectionCount count, int value) async {
    final items = _items;
    if (items == null) return false;

    final previous = items[profileId];
    final next = (previous ?? CollectionEntry.none).withCount(count, value);
    _apply(profileId, next);

    try {
      final res = await _client.collection.updateCollectionItem(
        profileId: profileId,
        collectionItemInput: api.CollectionItemInput(
          (b) => b
            ..item.owned = next.owned
            ..item.built = next.built
            ..item.painted = next.painted,
        ),
      );
      final confirmed = res.data;
      if (confirmed != null) _apply(profileId, CollectionEntry.from(confirmed));
      unawaited(_persist());
      return true;
    } on DioException {
      if (previous == null) {
        items.remove(profileId);
      } else {
        items[profileId] = previous;
      }
      notifyListeners();
      return false;
    }
  }

  void _apply(int profileId, CollectionEntry entry) {
    final items = _items;
    if (items == null) return;
    if (entry.isEmpty) {
      items.remove(profileId);
    } else {
      items[profileId] = entry;
    }
    notifyListeners();
  }

  Future<void> _persist() async {
    final items = _items;
    if (items == null) return;
    await CatalogCache.save(_cacheKey, [
      for (final e in items.entries)
        api.CollectionItem(
          (b) => b
            ..profileId = e.key
            ..owned = e.value.owned
            ..built = e.value.built
            ..painted = e.value.painted,
        ),
    ], const FullType(api.CollectionItem));
  }

  /// Drops the in-memory copy but keeps the cached one, so a test can exercise the cold-start
  /// restore path without hand-rolling a second service instance.
  @visibleForTesting
  void dropMemory() {
    _items = null;
    notifyListeners();
  }

  /// Drops the in-memory collection and the cached copy. Called on logout, so the next account
  /// never sees the last one's shelf.
  Future<void> reset() async {
    _items = null;
    notifyListeners();
    await CatalogCache.clear(_cacheKey);
  }
}
