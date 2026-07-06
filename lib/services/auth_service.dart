import 'dart:convert';

import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'api_client.dart';
import 'api_exception.dart';

class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.username,
  });

  final int id;
  final String email;
  final String username;
}

class AuthException implements Exception {
  AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._();
  factory AuthService() => _instance;

  AuthService._() {
    _client.onUnauthorized = _clear;
  }

  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  final _client = ApiClient();

  AuthUser? _currentUser;
  AuthUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  /// Puts the service into a logged-in state without touching secure storage, so tests can pump
  /// auth-gated screens. Not used in production.
  @visibleForTesting
  void debugLogin(AuthUser user, {String token = 'test-token'}) {
    _client.authToken = token;
    _currentUser = user;
    notifyListeners();
  }

  Future<void> load() async {
    final token = await _storage.read(key: _tokenKey);
    final rawUser = await _storage.read(key: _userKey);
    if (token == null || rawUser == null || isTokenExpired(token)) {
      await _clear();
      return;
    }
    _client.authToken = token;
    _currentUser = _userFromJson(rawUser);
    notifyListeners();
  }

  Future<void> signUp({
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      await _client.session.signup(
        registrationInput: api.RegistrationInput(
          (b) => b
            ..user = api.RegistrationInputUser(
              (ub) => ub
                ..username = username
                ..email = email
                ..password = password
                ..passwordConfirmation = passwordConfirmation,
            ).toBuilder(),
        ),
      );
    } on DioException catch (e) {
      throw AuthException(parseAuthError(e));
    }
  }

  Future<void> logIn({required String email, required String password}) async {
    try {
      final res = await _client.session.login(
        loginInput: api.LoginInput(
          (b) => b
            ..user = api.LoginInputUser(
              (ub) => ub
                ..email = email
                ..password = password,
            ).toBuilder(),
        ),
      );
      final authHeader = res.headers.value('authorization');
      final token = authHeader
          ?.replaceFirst(RegExp(r'^Bearer\s+', caseSensitive: false), '')
          .trim();
      if (token == null || token.isEmpty) {
        throw AuthException(
          'Login succeeded but no session token was returned.',
        );
      }
      final user = res.data!.user;
      final authUser = AuthUser(
        id: user.id,
        email: user.email,
        username: user.username,
      );

      _client.authToken = token;
      _currentUser = authUser;
      await _storage.write(key: _tokenKey, value: token);
      await _storage.write(key: _userKey, value: _userToJson(authUser));
      notifyListeners();
    } on DioException catch (e) {
      throw AuthException(
        parseAuthError(
          e,
          fallback: 'Invalid email or password, or account not yet confirmed.',
        ),
      );
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _client.session.forgotPassword(
        forgotPasswordInput: api.ForgotPasswordInput(
          (b) => b
            ..user = api.ForgotPasswordInputUser(
              (ub) => ub..email = email,
            ).toBuilder(),
        ),
      );
    } on DioException catch (e) {
      throw AuthException(parseAuthError(e));
    }
  }

  Future<void> resetPassword({
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      await _client.session.resetPassword(
        resetPasswordInput: api.ResetPasswordInput(
          (b) => b
            ..user = api.ResetPasswordInputUser(
              (ub) => ub
                ..resetPasswordToken = token
                ..password = password
                ..passwordConfirmation = passwordConfirmation,
            ).toBuilder(),
        ),
      );
    } on DioException catch (e) {
      throw AuthException(parseAuthError(e));
    }
  }

  Future<void> updateUsername(String username) async {
    try {
      final res = await _client.session.updateAccount(
        updateAccountInput: api.UpdateAccountInput(
          (b) => b
            ..user = api.UpdateAccountInputUser(
              (ub) => ub..username = username,
            ).toBuilder(),
        ),
      );
      final user = res.data!.user;
      final authUser = AuthUser(
        id: user.id,
        email: user.email,
        username: user.username,
      );
      _currentUser = authUser;
      await _storage.write(key: _userKey, value: _userToJson(authUser));
      notifyListeners();
    } on DioException catch (e) {
      throw AuthException(parseAuthError(e));
    }
  }

  Future<void> logOut() async {
    try {
      await _client.session.logout();
    } on DioException {
      // Clear the local session regardless of whether the server call succeeds.
    }
    await _clear();
  }

  Future<void> _clear() async {
    _client.authToken = null;
    _currentUser = null;
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
    notifyListeners();
  }

  @visibleForTesting
  bool isTokenExpired(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return true;
    try {
      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      final exp = payload['exp'];
      // A token we can't read an expiry from is untrustworthy — treat it as expired so we
      // re-authenticate rather than trusting a possibly-stale credential indefinitely.
      if (exp is! int) return true;
      return DateTime.fromMillisecondsSinceEpoch(
        exp * 1000,
      ).isBefore(DateTime.now());
    } catch (_) {
      return true;
    }
  }

  String _userToJson(AuthUser u) =>
      json.encode({'id': u.id, 'email': u.email, 'username': u.username});

  AuthUser _userFromJson(String raw) {
    final map = json.decode(raw) as Map<String, dynamic>;
    return AuthUser(
      id: map['id'] as int,
      email: map['email'] as String,
      username: map['username'] as String,
    );
  }

  // Delegates to the shared parser so auth and the other services share one error contract (F-P2-2).
  @visibleForTesting
  String parseAuthError(DioException e, {String? fallback}) =>
      ApiException.from(e, fallback: fallback).message;
}
