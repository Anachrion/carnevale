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

import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter/foundation.dart';

import '../services/collection_service.dart';
import 'profile.dart';

/// One model the gang asks for more copies of than the player owns.
@immutable
class GangShortfall {
  const GangShortfall({
    required this.name,
    required this.hired,
    required this.owned,
  });

  final String name;
  final int hired;
  final int owned;

  int get missing => hired - owned;
}

/// What a gang would look like on the table, given what is actually on the shelf (CARNEVALEB-76).
///
/// The four counts are **exclusive** and sum to [total]: a miniature is painted, or built but not
/// painted, or owned but not built, or not owned at all. The stored model nests instead (every
/// painted one is also built), but nested numbers shown side by side in one bar would double-count
/// and misreport the total — so they are split here, once, rather than at each call site.
@immutable
class GangCollectionSummary {
  const GangCollectionSummary({
    required this.total,
    required this.painted,
    required this.unpainted,
    required this.boxed,
    required this.missing,
    required this.shortfalls,
  });

  /// Miniatures this gang puts on the table.
  final int total;

  final int painted;
  final int unpainted;
  final int boxed;
  final int missing;

  /// The models the player is short of, worst gap first.
  final List<GangShortfall> shortfalls;

  bool get isComplete => missing == 0;

  /// Reads a gang against the collection.
  ///
  /// Only hired card-reference entries count: equipment is not a miniature, and a model conjured
  /// mid-game by a special rule was never bought. A *transformed* model is counted as the profile
  /// it was hired as rather than the one it currently is — the player owns one miniature either
  /// way, and `entryId` still names the hired card, so this falls out of the lookup rather than
  /// needing a special case.
  factory GangCollectionSummary.of({
    required Iterable<api.ListEntry> entries,
    required List<api.Profile> profiles,
    CollectionEntry Function(int profileId)? lookup,
  }) {
    final collection = lookup ?? CollectionService().entryFor;

    final hired = <int, ({api.Profile profile, int count})>{};
    for (final entry in entries) {
      if (entry.entryType !=
          api.ListEntryEntryTypeEnum.catalogColonColonCardReference) {
        continue;
      }
      if (entry.summoned) continue;
      final profile = profiles
          .where((p) => p.cardReferenceIds.contains(entry.entryId))
          .firstOrNull;
      if (profile == null) continue;
      final seen = hired[profile.id];
      hired[profile.id] = (profile: profile, count: (seen?.count ?? 0) + 1);
    }

    var total = 0, painted = 0, unpainted = 0, boxed = 0, missing = 0;
    final shortfalls = <GangShortfall>[];

    for (final entry in hired.values) {
      final count = entry.count;
      final owned = collection(entry.profile.id);
      // Cover the copies this gang needs from the best miniatures available, best first.
      final coveredPainted = owned.painted.clamp(0, count);
      final coveredBuilt = owned.built.clamp(0, count);
      final coveredOwned = owned.owned.clamp(0, count);

      total += count;
      painted += coveredPainted;
      unpainted += coveredBuilt - coveredPainted;
      boxed += coveredOwned - coveredBuilt;
      final short = count - coveredOwned;
      missing += short;
      if (short > 0) {
        shortfalls.add(
          GangShortfall(
            name: entry.profile.name,
            hired: count,
            owned: owned.owned,
          ),
        );
      }
    }

    shortfalls.sort((a, b) {
      final byGap = b.missing.compareTo(a.missing);
      return byGap != 0 ? byGap : a.name.compareTo(b.name);
    });

    return GangCollectionSummary(
      total: total,
      painted: painted,
      unpainted: unpainted,
      boxed: boxed,
      missing: missing,
      shortfalls: shortfalls,
    );
  }
}
