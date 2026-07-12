import 'package:test/test.dart';
import 'package:carnevale_api/carnevale_api.dart';

/// tests for SessionApi
void main() {
  final instance = CarnevaleApi().getSessionApi();

  group(SessionApi, () {
    // Log in and receive a JWT
    //
    // On success, the JWT is returned in the `Authorization` response header as `Bearer <token>`. Send it back on subsequent requests to authenticate.
    //
    //Future<Session> login(LoginInput loginInput) async
    test('test login', () async {
      // TODO
    });

    // Revoke the current JWT
    //
    //Future logout() async
    test('test logout', () async {
      // TODO
    });

    // Register a new user
    //
    // Creates the user and sends a confirmation email. The user cannot log in until the confirmation link has been clicked.
    //
    //Future<Session> signup(RegistrationInput registrationInput) async
    test('test signup', () async {
      // TODO
    });
  });
}
