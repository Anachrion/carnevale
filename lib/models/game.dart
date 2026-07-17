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

import 'package:carnevale_api/carnevale_api.dart' as api;

/// Convenience on the generated game model (F-P2-1 replaced the hand-written Game/GamePlayer with
/// api.Game/api.GamePlayer; this keeps the one helper the screens relied on).
extension GameX on api.Game {
  api.GamePlayer? playerFor(int userId) =>
      players.where((p) => p.userId == userId).firstOrNull;
}
