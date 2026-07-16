import 'dart:convert';

import 'package:carnevale/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

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
}
