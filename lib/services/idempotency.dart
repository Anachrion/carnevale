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
