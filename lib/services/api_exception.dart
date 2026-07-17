// Copyright 2026 Anachrion
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
