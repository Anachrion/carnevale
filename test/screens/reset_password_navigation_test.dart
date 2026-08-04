import 'package:carnevale/l10n/app_localizations.dart';
import 'package:carnevale/screens/account_screen.dart';
import 'package:carnevale/screens/home_screen.dart';
import 'package:carnevale/screens/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';

void main() {
  // A reset link is opened on top of the home screen: main.dart pushes ResetPasswordScreen onto the
  // root, so the stack is [HomeScreen, ResetPasswordScreen].
  Future<GlobalKey<NavigatorState>> pumpResetOnTopOfHome(
    WidgetTester tester,
  ) async {
    final navKey = GlobalKey<NavigatorState>();
    await tester.pumpWidget(
      MaterialApp(
        navigatorKey: navKey,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomeScreen(),
      ),
    );
    navKey.currentState!.push(
      MaterialPageRoute(builder: (_) => const ResetPasswordScreen(token: 'tok')),
    );
    await tester.pumpAndSettle();
    return navKey;
  }

  Future<void> submitNewPassword(WidgetTester tester) async {
    await tester.enterText(find.byType(TextFormField).at(0), 'NewSecret123!');
    await tester.enterText(find.byType(TextFormField).at(1), 'NewSecret123!');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    // The success toast dismisses itself on a 1.8s Future.delayed; leaving it pending fails the
    // test on the binding's "a Timer is still pending" check rather than on any assertion.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  }

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    installFakeApi().stub('PATCH', '/password', {
      'user': {'id': 4, 'email': 'reset@example.com', 'username': 'Sechs'},
      'refresh_token': 'refresh-abc',
    }, headers: {'authorization': 'Bearer token'});
  });

  testWidgets('a completed reset shows the account screen', (tester) async {
    await pumpResetOnTopOfHome(tester);

    await submitNewPassword(tester);

    expect(find.byType(AccountScreen), findsOneWidget);
    expect(find.byType(ResetPasswordScreen), findsNothing);
  });

  // The reset used to clear the whole stack, which made the account screen the *root*. The drawer
  // reaches home with popUntil((r) => r.isFirst), so "Home" landed back on the account screen for
  // the rest of the session with no way out — reported on Firefox/macOS after a real reset.
  testWidgets('home is still reachable after a completed reset', (
    tester,
  ) async {
    final navKey = await pumpResetOnTopOfHome(tester);

    await submitNewPassword(tester);
    // What AppDrawer does for AppDrawerRoute.home.
    navKey.currentState!.popUntil((r) => r.isFirst);
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(AccountScreen), findsNothing);
  });

  // Going back must not offer the form again: its token is single-use and has just been spent, so
  // resubmitting it can only produce "reset_password_token is invalid".
  testWidgets('the spent reset form is gone from the back stack', (
    tester,
  ) async {
    final navKey = await pumpResetOnTopOfHome(tester);

    await submitNewPassword(tester);
    navKey.currentState!.pop();
    await tester.pumpAndSettle();

    expect(find.byType(ResetPasswordScreen), findsNothing);
    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
