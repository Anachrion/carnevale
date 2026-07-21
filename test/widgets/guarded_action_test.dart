import 'package:carnevale/services/api_exception.dart';
import 'package:carnevale/widgets/guarded_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/l10n.dart';

void main() {
  Future<BuildContext> pumpHost(WidgetTester tester) async {
    late BuildContext ctx;
    await tester.pumpWidget(
      localizedApp(
        home: Builder(
          builder: (c) {
            ctx = c;
            return const Scaffold(body: SizedBox());
          },
        ),
      ),
    );
    return ctx;
  }

  // Toasts self-dismiss after ~1.8s via a delayed callback; drain it so no timer is left pending.
  Future<void> drainToast(WidgetTester tester) async {
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets('returns true and shows no toast when the action succeeds', (
    tester,
  ) async {
    final ctx = await pumpHost(tester);

    final ok = await guard(ctx, () async {});
    await tester.pump();

    expect(ok, isTrue);
    expect(find.byType(Text), findsNothing);
  });

  testWidgets('toasts the ApiException message and returns false', (
    tester,
  ) async {
    final ctx = await pumpHost(tester);

    final ok = await guard(
      ctx,
      () async => throw ApiException('Gangs can no longer be changed'),
    );
    await tester.pump(); // insert the toast overlay
    await tester.pump(const Duration(milliseconds: 300)); // fade it in

    expect(ok, isFalse);
    expect(find.text('Gangs can no longer be changed'), findsOneWidget);

    await drainToast(tester);
  });

  testWidgets('shows a generic message for a non-ApiException and returns false', (
    tester,
  ) async {
    final ctx = await pumpHost(tester);

    final ok = await guard(ctx, () async => throw StateError('boom'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(ok, isFalse);
    expect(find.text('Something went wrong. Please try again.'), findsOneWidget);

    await drainToast(tester);
  });
}
