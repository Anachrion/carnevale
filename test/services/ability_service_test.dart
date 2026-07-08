import 'package:carnevale/services/ability_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AbilityService.baseName', () {
    test('strips a numeric "(X)" rating', () {
      expect(AbilityService.baseName('Acrobatic (2)'), 'Acrobatic');
      expect(AbilityService.baseName('Reload (1)'), 'Reload');
    });

    test('passes through an ability with no rating', () {
      expect(AbilityService.baseName('Aerial Attack'), 'Aerial Attack');
      expect(AbilityService.baseName('Two-handed'), 'Two-handed');
    });

    test('strips a keyword/name rating', () {
      expect(AbilityService.baseName('Bodyguard (Doctor)'), 'Bodyguard');
      expect(AbilityService.baseName('Companion (Il Fantoccio)'), 'Companion');
    });

    test('handles missing space before the rating', () {
      expect(AbilityService.baseName('Fear(1)'), 'Fear');
    });
  });
}
