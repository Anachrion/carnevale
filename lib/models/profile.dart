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
