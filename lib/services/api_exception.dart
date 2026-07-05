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
            final messages = (entry.value as List)
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
