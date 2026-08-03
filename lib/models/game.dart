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

/// Convenience on the generated game model (F-P2-1 replaced the hand-written Game/GamePlayer with
/// api.Game/api.GamePlayer; this keeps the one helper the screens relied on).
extension GameX on api.Game {
  api.GamePlayer? playerFor(int userId) =>
      players.where((p) => p.userId == userId).firstOrNull;
}
