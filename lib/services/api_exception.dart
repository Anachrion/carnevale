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

import 'package:dio/dio.dart';

/// A uniform, user-presentable error for every API call, so screens catch one type with a
/// human-readable [message] instead of raw DioExceptions (or null-bang crashes). Services wrap
/// their calls so the whole app shares one error contract (F-P2-2).
class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;

  /// Builds an ApiException from a DioException, parsing the API's error body. The backend uses
  /// two shapes — `{ "errors": { "base": [...], "<field>": [...] } }` — both handled here.
  factory ApiException.from(DioException error, {String? fallback}) {
    final data = error.response?.data;
    final status = error.response?.statusCode;
    if (data is Map && data['errors'] is Map) {
      final message = (data['errors'] as Map).entries
          .map((entry) {
            final field = entry.key.toString();
            // Values are usually arrays of strings, but a single string (or any scalar) shows up
            // too; coerce so an unexpected shape can't turn the error path into a TypeError crash.
            final value = entry.value;
            final messages = (value is List ? value : [value])
                .map((m) => m.toString())
                .join(', ');
            return field == 'base' ? messages : '$field $messages';
          })
          .join('\n');
      if (message.isNotEmpty) return ApiException(message, statusCode: status);
    }
    return ApiException(
      fallback ?? 'Something went wrong. Please try again.',
      statusCode: status,
    );
  }
}
