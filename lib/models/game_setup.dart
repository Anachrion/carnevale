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

import '../services/api_client.dart';

/// A game's settings, agreed before anyone creates it (CARNEVALEB-74).
///
/// Two players settle on a scenario, a Ducat limit and a board size before one of them hosts. This
/// carries that agreement in a link, so the one who *isn't* hosting can still be the one who chose:
/// they fill the form, share it, and their opponent opens it already filled in.
///
/// Everything rides in the query string rather than in a record on the server. The values are four
/// small public settings — there is nothing to keep, nothing to expire, and nothing to leak — so a
/// stored setup would buy only an id to look up, at the cost of an endpoint and a lifetime.
///
/// The scenario travels **by name**, not by id: it reads plainly in a URL, and it survives ids
/// drifting between a dev database and production. Same reasoning as the gang text format.
class GameSetup {
  const GameSetup({
    this.scenarioName,
    this.name,
    this.ducatLimit,
    this.boardSize,
  });

  final String? scenarioName;
  final String? name;
  final int? ducatLimit;
  final String? boardSize;

  static const path = '/new-game';

  /// Null when the link carries nothing usable, so a bare `/new-game` opens an empty form rather
  /// than pretending a setup was shared.
  static GameSetup? fromUri(Uri uri) {
    final q = uri.queryParameters;
    final setup = GameSetup(
      scenarioName: _clean(q['scenario']),
      name: _clean(q['name']),
      ducatLimit: int.tryParse(q['ducats'] ?? ''),
      boardSize: _clean(q['board']),
    );
    return setup.isEmpty ? null : setup;
  }

  bool get isEmpty =>
      scenarioName == null &&
      name == null &&
      ducatLimit == null &&
      boardSize == null;

  /// The shareable link. Empty fields are left out entirely rather than sent blank, so the URL
  /// stays short and a recipient's form is only pre-filled where a choice was actually made.
  String toUrl() {
    final query = <String, String>{
      'scenario': ?scenarioName,
      'name': ?name,
      if (ducatLimit != null) 'ducats': '$ducatLimit',
      'board': ?boardSize,
    };
    return Uri.parse(
      '${ApiClient.origin}${GameSetup.path}',
    ).replace(queryParameters: query).toString();
  }

  static String? _clean(String? value) {
    final trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }
}
