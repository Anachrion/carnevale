import 'gang.dart';
import 'profile.dart';

class ValidationResult {
  final bool valid;
  final String? reason;

  const ValidationResult._({required this.valid, this.reason});

  factory ValidationResult.ok() => const ValidationResult._(valid: true);
  factory ValidationResult.error(String reason) =>
      ValidationResult._(valid: false, reason: reason);
}

class GangValidator {
  static ValidationResult canAdd(Gang gang, Profile candidate) {
    if (gang.totalCost + candidate.ducats > gang.points) {
      return ValidationResult.error('Not enough ducats');
    }

    if (candidate.faction != gang.faction && candidate.faction != 'gifted') {
      return ValidationResult.error('Wrong faction');
    }

    if (candidate.keywords.contains('Unique') &&
        gang.entries.any((e) => e.entryType == 'CardReference' && e.entryId == candidate.cardReferenceId)) {
      return ValidationResult.error('Unique — already hired');
    }

    return ValidationResult.ok();
  }
}
