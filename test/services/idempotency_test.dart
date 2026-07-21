import 'package:carnevale/services/idempotency.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('newIdempotencyKey', () {
    // Must satisfy the backend's AcceptsIdempotencyKey bound (/\A[A-Za-z0-9._-]{16,128}\z/), or the
    // server silently drops the key and the retry-dedup this whole feature relies on stops working.
    final serverBound = RegExp(r'^[A-Za-z0-9._-]{16,128}$');

    test('is within the format the backend accepts', () {
      for (var i = 0; i < 100; i++) {
        expect(serverBound.hasMatch(newIdempotencyKey()), isTrue);
      }
    });

    test('is unique across calls', () {
      final keys = List.generate(1000, (_) => newIdempotencyKey());
      expect(keys.toSet().length, 1000);
    });
  });
}
