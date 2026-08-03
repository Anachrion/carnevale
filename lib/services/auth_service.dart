// Carnevale Companion
// Copyright (C) 2026 Anachrion and contributors
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU Affero General Public License as published by the Free
// Software Foundation, either version 3 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
// details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program. If not, see <https://www.gnu.org/licenses/>.

import 'dart:convert';

import 'package:carnevale_api/carnevale_api.dart' as api;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'api_client.dart';
import 'api_exception.dart';
import 'game_service.dart';
import 'gang_service.dart';

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
    _client.performRefresh = _refreshSession;
  }

  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';
  static const _refreshTokenKey = 'refresh_token';
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
    if (rawUser == null) {
      await _clear();
      return;
    }
    if (token != null && !isTokenExpired(token)) {
      _client.authToken = token;
      _currentUser = _userFromJson(rawUser);
      notifyListeners();
      return;
    }
    // The stored access token is missing or expired. Rather than forcing a login, mint a fresh one
    // from the refresh token; only clear the session if that fails (refresh token expired/revoked).
    if (await _refreshSession() != null) {
      _currentUser = _userFromJson(rawUser);
      notifyListeners();
    } else {
      await _clear();
    }
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

  Future<void> logIn({required String login, required String password}) async {
    try {
      // Called through the raw Dio rather than the generated client so the response body's
      // `refresh_token` (a field the generated Session model doesn't carry) is readable alongside
      // the JWT header — the same raw-endpoint approach used for cable tickets.
      // The backend still reads this under the `email` key (Devise's authentication_keys is
      // unchanged) but now accepts either the account's email or its username as the value.
      final res = await _client.dio.post<Map<String, dynamic>>(
        '/login',
        data: {
          'user': {'email': login, 'password': password},
        },
      );
      final token = _bearer(res.headers.value('authorization'));
      final refresh = res.data?['refresh_token'] as String?;
      final userMap = res.data?['user'] as Map<String, dynamic>?;
      if (token == null || refresh == null || refresh.isEmpty || userMap == null) {
        throw AuthException(
          'Login succeeded but no session token was returned.',
        );
      }
      final authUser = AuthUser(
        id: userMap['id'] as int,
        email: userMap['email'] as String,
        username: userMap['username'] as String,
      );

      _client.authToken = token;
      _currentUser = authUser;
      await _storage.write(key: _tokenKey, value: token);
      await _storage.write(key: _refreshTokenKey, value: refresh);
      await _storage.write(key: _userKey, value: _userToJson(authUser));
      notifyListeners();
    } on DioException catch (e) {
      throw AuthException(
        parseAuthError(
          e,
          fallback:
              'Invalid email/username or password, or account not yet confirmed.',
        ),
      );
    }
  }

  /// Trades the stored refresh token for a fresh access JWT (and a rotated refresh token), updating
  /// storage and the client, and returns the new access token — or null if there is no refresh
  /// token or the server rejects it. Wired into [ApiClient.performRefresh] so a 401 recovers
  /// silently, and used by [load] to resume a session whose access token has expired.
  Future<String?> _refreshSession() async {
    final refresh = await _storage.read(key: _refreshTokenKey);
    if (refresh == null || refresh.isEmpty) return null;
    try {
      final res = await _client.dio.post<Map<String, dynamic>>(
        '/token',
        data: {'refresh_token': refresh},
      );
      final token = _bearer(res.headers.value('authorization'));
      final newRefresh = res.data?['refresh_token'] as String?;
      if (token == null || newRefresh == null || newRefresh.isEmpty) return null;
      _client.authToken = token;
      await _storage.write(key: _tokenKey, value: token);
      await _storage.write(key: _refreshTokenKey, value: newRefresh);
      return token;
    } on DioException {
      return null;
    }
  }

  /// Strips the `Bearer ` prefix from an Authorization header, returning null for a missing or
  /// empty value so callers can treat "no token" uniformly.
  String? _bearer(String? header) {
    if (header == null) return null;
    final token = header
        .replaceFirst(RegExp(r'^Bearer\s+', caseSensitive: false), '')
        .trim();
    return token.isEmpty ? null : token;
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
      final user = res.data?.user;
      if (user == null) {
        throw AuthException('The server returned no account details.');
      }
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
    // The gangs and games index caches are per-user; drop them so the next account never sees the
    // last one's lists.
    GangService().resetGangsCache();
    GameService().resetGamesCache();
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _refreshTokenKey);
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
