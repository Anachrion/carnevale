import 'dart:convert';

import 'package:carnevale/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fake_api.dart';

String _fakeToken(Map<String, dynamic> payload) {
  String encode(Object o) =>
      base64Url.encode(utf8.encode(json.encode(o))).replaceAll('=', '');
  return '${encode({'alg': 'HS256'})}.${encode(payload)}.signature';
}

DioException _errorResponse(Object? data, {int statusCode = 422}) {
  final requestOptions = RequestOptions(path: '/x');
  return DioException(
    requestOptions: requestOptions,
    response: Response(
      requestOptions: requestOptions,
      statusCode: statusCode,
      data: data,
    ),
  );
}

void main() {
  final auth = AuthService();

  group('isTokenExpired', () {
    test('returns true for a token whose exp has passed', () {
      final past = DateTime.now().subtract(const Duration(hours: 1));
      final token = _fakeToken({'exp': past.millisecondsSinceEpoch ~/ 1000});
      expect(auth.isTokenExpired(token), isTrue);
    });

    test('returns false for a token whose exp is in the future', () {
      final future = DateTime.now().add(const Duration(hours: 1));
      final token = _fakeToken({'exp': future.millisecondsSinceEpoch ~/ 1000});
      expect(auth.isTokenExpired(token), isFalse);
    });

    test('returns true when the payload has no exp claim', () {
      // A token we can't read an expiry from is treated as expired, so we re-authenticate
      // rather than trusting a credential of unknown validity (F-P3-5).
      final token = _fakeToken({'sub': '1'});
      expect(auth.isTokenExpired(token), isTrue);
    });

    test('returns true for a malformed token', () {
      expect(auth.isTokenExpired('not-a-jwt'), isTrue);
    });

    test('returns true when the payload segment is not valid base64/JSON', () {
      expect(auth.isTokenExpired('header.!!!not-base64!!!.sig'), isTrue);
    });
  });

  group('parseAuthError', () {
    test('formats a single validation error with its field name', () {
      final e = _errorResponse({
        'errors': {
          'email': ['has already been taken'],
        },
      });
      expect(auth.parseAuthError(e), 'email has already been taken');
    });

    test('joins multiple field errors on separate lines', () {
      final e = _errorResponse({
        'errors': {
          'email': ['has already been taken'],
          'username': ['has already been taken', 'is too short'],
        },
      });
      expect(
        auth.parseAuthError(e),
        'email has already been taken\nusername has already been taken, is too short',
      );
    });

    test('drops the field name for a "base" error', () {
      final e = _errorResponse({
        'errors': {
          'base': ['something went wrong'],
        },
      });
      expect(auth.parseAuthError(e), 'something went wrong');
    });

    test('handles a scalar (non-array) error value without crashing', () {
      // A-12: some error shapes carry a bare string instead of an array; the parser used to
      // blindly cast to List and throw a TypeError on the error path itself.
      final e = _errorResponse({
        'errors': {
          'base': 'something went wrong',
        },
      });
      expect(auth.parseAuthError(e), 'something went wrong');
    });

    test('falls back to the provided message when there is no errors map', () {
      final e = _errorResponse({
        'error': 'Invalid email or password.',
      }, statusCode: 401);
      expect(auth.parseAuthError(e, fallback: 'nope'), 'nope');
    });

    test('falls back to a generic message when none is provided', () {
      final e = _errorResponse(null, statusCode: 500);
      expect(auth.parseAuthError(e), 'Something went wrong. Please try again.');
    });
  });

  group('resetPassword', () {
    setUp(() => FlutterSecureStorage.setMockInitialValues({}));

    // Completing a reset signs the user in, so the screen can land on the account without asking
    // for the password just chosen. Reading the response used to go through the generated client,
    // which deserializes into `Session` — whose `refreshToken` is non-nullable — while the backend
    // returned `{user: …}` alone. Every *successful* reset therefore threw and was reported as a
    // generic failure; the user retried and hit "token is invalid", the first attempt having
    // actually worked. This pins the whole session down.
    test('stores the session returned with a completed reset', () async {
      final adapter = installFakeApi();
      final jwt = _fakeToken({
        'exp':
            DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch ~/
                1000,
      });
      adapter.stub(
        'PATCH',
        '/password',
        {
          'user': {'id': 4, 'email': 'reset@example.com', 'username': 'Sechs'},
          'refresh_token': 'refresh-abc',
        },
        headers: {'authorization': 'Bearer $jwt'},
      );

      await auth.resetPassword(
        token: 'reset-token',
        password: 'NewSecret123!',
        passwordConfirmation: 'NewSecret123!',
      );

      expect(auth.currentUser?.id, 4);
      expect(auth.currentUser?.username, 'Sechs');
      expect(
        await const FlutterSecureStorage().read(key: 'refresh_token'),
        'refresh-abc',
      );
      expect(await const FlutterSecureStorage().read(key: 'auth_token'), jwt);
    });

    // A 2xx means the password was changed even if the session is unusable. Saying so matters:
    // a plain "failed" invites the retry that spends the single-use token and produces the
    // misleading "token is invalid".
    test('reports the password as changed when the session is missing', () async {
      final adapter = installFakeApi();
      adapter.stub('PATCH', '/password', {
        'user': {'id': 4, 'email': 'reset@example.com', 'username': 'Sechs'},
      });

      await expectLater(
        auth.resetPassword(
          token: 'reset-token',
          password: 'NewSecret123!',
          passwordConfirmation: 'NewSecret123!',
        ),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            contains('password was changed'),
          ),
        ),
      );
    });

    test('sends the token and both password fields under `user`', () async {
      final adapter = installFakeApi();
      adapter.stub('PATCH', '/password', {
        'user': {'id': 4, 'email': 'reset@example.com', 'username': 'Sechs'},
        'refresh_token': 'refresh-abc',
      }, headers: {'authorization': 'Bearer token'});

      await auth.resetPassword(
        token: 'reset-token',
        password: 'NewSecret123!',
        passwordConfirmation: 'NewSecret123!',
      );

      final sent = adapter.requests.single.data as Map<String, dynamic>;
      expect(sent['user'], {
        'reset_password_token': 'reset-token',
        'password': 'NewSecret123!',
        'password_confirmation': 'NewSecret123!',
      });
    });
  });

  group('signUp', () {
    // AuthService is a singleton, so a test that signs in leaves the next one signed in. Start
    // each from a clean signed-out state — `logOut` clears locally even when the call fails, and
    // the route is deliberately unstubbed here.
    setUp(() async {
      FlutterSecureStorage.setMockInitialValues({});
      installFakeApi();
      await auth.logOut();
    });

    // The exact body the backend returns from POST /signup: the created account, no credentials.
    const createdAccount = {
      'user': {'id': 9, 'email': 'new@example.com', 'username': 'Neun'},
    };

    Future<void> signUp() => auth.signUp(
      username: 'Neun',
      email: 'new@example.com',
      password: 'Secret123!',
      passwordConfirmation: 'Secret123!',
    );

    // CARNEVALEB-73. `/signup` was documented as returning a `Session`, whose `refresh_token` is
    // non-nullable, while the controller has always returned `{user: …}` alone. The generated
    // client threw on every *successful* registration, `signUp` reported it as a failure, and the
    // account had in fact been created — so the user retried and was told their email was already
    // taken. Nothing below the client saw the problem: the backend request spec asserts the HTTP
    // status, not what the Dart client can do with the body. This is that boundary.
    test('succeeds on the account-shaped body the backend actually returns', () async {
      final adapter = installFakeApi();
      adapter.stub('POST', '/signup', createdAccount);
      final jwt = _fakeToken({
        'exp':
            DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch ~/
                1000,
      });
      adapter.stub('POST', '/login', {
        'user': {'id': 9, 'email': 'new@example.com', 'username': 'Neun'},
        'refresh_token': 'refresh-neun',
      }, headers: {'authorization': 'Bearer $jwt'});

      await expectLater(signUp(), completes);
    });

    // Registering doesn't issue a session, so the UI's "Account created!" -> home screen would
    // land a brand-new user there signed out.
    test('signs the new user in', () async {
      final adapter = installFakeApi();
      adapter.stub('POST', '/signup', createdAccount);
      final jwt = _fakeToken({
        'exp':
            DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch ~/
                1000,
      });
      adapter.stub('POST', '/login', {
        'user': {'id': 9, 'email': 'new@example.com', 'username': 'Neun'},
        'refresh_token': 'refresh-neun',
      }, headers: {'authorization': 'Bearer $jwt'});

      await signUp();

      expect(auth.isLoggedIn, isTrue);
      expect(auth.currentUser?.id, 9);
      expect(auth.currentUser?.username, 'Neun');
      expect(
        await const FlutterSecureStorage().read(key: 'refresh_token'),
        'refresh-neun',
      );
      // The sign-in reuses the credentials just registered, under the login key the backend reads.
      final login = adapter.requests.last.data as Map<String, dynamic>;
      expect(login['user'], {
        'email': 'new@example.com',
        'password': 'Secret123!',
      });
    });

    // A genuine rejection must still reach the user verbatim — this is the path that tells them
    // the email is taken or the password is too short.
    test('surfaces a validation error from the server', () async {
      installFakeApi(); // unstubbed: the adapter answers 404 with an errors map

      await expectLater(
        signUp(),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            contains('not stubbed'),
          ),
        ),
      );
      expect(auth.isLoggedIn, isFalse);
    });

    // If registration worked but the follow-up sign-in didn't, saying "signup failed" is what
    // sends the user back to the form to be told their email is already taken — the original bug.
    test('reports a created account when only the sign-in fails', () async {
      final adapter = installFakeApi();
      adapter.stub('POST', '/signup', createdAccount);
      // /login left unstubbed, so the sign-in fails after the account exists.

      await expectLater(
        signUp(),
        throwsA(
          isA<AuthException>().having(
            (e) => e.message,
            'message',
            allOf(contains('account was created'), contains('log in')),
          ),
        ),
      );
      expect(adapter.requests.map((r) => r.path), ['/signup', '/login']);
    });
  });

  group('logOut', () {
    void signIn({String? refreshToken = 'refresh-abc'}) {
      FlutterSecureStorage.setMockInitialValues({
        'auth_token': 'jwt-abc',
        'auth_user': json.encode({
          'id': 4,
          'email': 'a@b.c',
          'username': 'Sechs',
        }),
        'refresh_token': ?refreshToken,
      });
      auth.debugLogin(const AuthUser(id: 4, email: 'a@b.c', username: 'Sechs'));
    }

    // The whole reason logOut sends a body: without this device's refresh token the backend
    // revokes every one the user holds, which is what used to sign the phone out hours after a
    // logout in the browser. Pinned here because it's invisible from the UI — both shapes look
    // like a successful sign-out on the device that asked for it.
    test('names this device\'s refresh token so other devices stay signed in', () async {
      final adapter = installFakeApi();
      adapter.stub('DELETE', '/logout', null);
      signIn();

      await auth.logOut();

      final request = adapter.requests.single;
      expect(request.path, '/logout');
      expect(request.data, {'refresh_token': 'refresh-abc'});
    });

    // No stored token means nothing to name, and the backend's documented fallback is to revoke
    // everything. Signing out too widely is the safe direction to fail in, so this sends no body
    // rather than refusing to sign out at all.
    test('sends no body when this device has no stored refresh token', () async {
      final adapter = installFakeApi();
      adapter.stub('DELETE', '/logout', null);
      signIn(refreshToken: null);

      await auth.logOut();

      expect(adapter.requests.single.data, isNull);
    });

    test('clears the local session', () async {
      final adapter = installFakeApi();
      adapter.stub('DELETE', '/logout', null);
      signIn();

      await auth.logOut();

      expect(auth.currentUser, isNull);
      expect(auth.isLoggedIn, isFalse);
      const storage = FlutterSecureStorage();
      expect(await storage.read(key: 'auth_token'), isNull);
      expect(await storage.read(key: 'refresh_token'), isNull);
      expect(await storage.read(key: 'auth_user'), isNull);
    });

    // A user who taps sign out must end up signed out on the device whatever the server says —
    // otherwise a flaky connection strands them in a session they asked to end. The route is left
    // unstubbed here, so the adapter answers 404.
    test('clears the local session even when the server call fails', () async {
      installFakeApi();
      signIn();

      await auth.logOut();

      expect(auth.currentUser, isNull);
      expect(
        await const FlutterSecureStorage().read(key: 'refresh_token'),
        isNull,
      );
    });

    // The destructive sibling: a distinct endpoint, and no token named, because revoking all of
    // them is the point rather than the fallback.
    test('logOutEverywhere hits /logout_all with no body', () async {
      final adapter = installFakeApi();
      adapter.stub('DELETE', '/logout_all', null);
      signIn();

      await auth.logOutEverywhere();

      expect(adapter.requests.single.path, '/logout_all');
      expect(adapter.requests.single.data, isNull);
      expect(auth.currentUser, isNull);
    });
  });
}
