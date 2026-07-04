import 'package:built_value/serializer.dart';
import 'package:carnevale/services/game_service.dart';
import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:flutter_test/flutter_test.dart';

void main() {
  final service = GameService();

  group('wireEnum', () {
    test('converts a multi-word enum constant to its snake_case wire value', () {
      expect(
        service.wireEnum(api.GameStatusEnum.gangSelection, const FullType(api.GameStatusEnum)),
        'gang_selection',
      );
      expect(
        service.wireEnum(api.GameStatusEnum.inProgress, const FullType(api.GameStatusEnum)),
        'in_progress',
      );
    });

    test('matches the documented wire value for every status', () {
      const expected = {
        api.GameStatusEnum.pending: 'pending',
        api.GameStatusEnum.gangSelection: 'gang_selection',
        api.GameStatusEnum.agendaDraw: 'agenda_draw',
        api.GameStatusEnum.deploying: 'deploying',
        api.GameStatusEnum.inProgress: 'in_progress',
        api.GameStatusEnum.completed: 'completed',
      };
      for (final entry in expected.entries) {
        expect(service.wireEnum(entry.key, const FullType(api.GameStatusEnum)), entry.value);
      }
    });
  });
}
