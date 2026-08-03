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

import 'dart:math';

/// The HTTP header the backend reads to dedupe a re-sent additive mutation (hire / summon).
const idempotencyKeyHeader = 'Idempotency-Key';

/// A fresh opaque idempotency token (128-bit, hex). Mint one per logical mutation and **reuse it
/// across every retry of that mutation** — the builder's optimistic sync queue re-sends a lost op,
/// and the server replays the original row for a repeated key instead of duplicating it. A new
/// key means a new action.
String newIdempotencyKey() {
  final random = Random.secure();
  return List<int>.generate(16, (_) => random.nextInt(256))
      .map((b) => b.toRadixString(16).padLeft(2, '0'))
      .join();
}
