import 'package:carnevale_api/carnevale_api.dart' as api;

/// Aggregation helpers on the generated profile model (F-P2-1 replaced the hand-written Profile;
/// these keep the derived fields the screens relied on). A profile can be printed as more than one
/// physical card (e.g. "(A)"/"(B)" copies sharing art), so it flattens all card_references.
extension ProfileX on api.Profile {
  List<int> get cardReferenceIds => cardReferences.map((r) => r.id).toList();

  /// Any card reference identifies this profile; this picks one to send when hiring a new copy,
  /// where it doesn't matter which. Null when the profile has no printed card (so it can't be
  /// hired) — previously a magic `0` that callers sent straight to the hire API.
  int? get cardReferenceId =>
      cardReferences.isEmpty ? null : cardReferences.first.id;

  String get frontImage =>
      cardReferences.isEmpty ? '' : (cardReferences.first.cardFront ?? '');
  String get backImage =>
      cardReferences.isEmpty ? '' : (cardReferences.first.cardBack ?? '');
}
