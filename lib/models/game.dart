import 'package:carnevale_api/carnevale_api.dart' as api;

/// Convenience on the generated game model (F-P2-1 replaced the hand-written Game/GamePlayer with
/// api.Game/api.GamePlayer; this keeps the one helper the screens relied on).
extension GameX on api.Game {
  api.GamePlayer? playerFor(int userId) =>
      players.where((p) => p.userId == userId).firstOrNull;
}
