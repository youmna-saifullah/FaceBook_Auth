import 'package:flutter/foundation.dart';

/// Structured logging service with no print statements.
class LoggerService {
  static const String _tag = '[FacebookAuth]';

  /// Log info level messages
  static void info(String message, {String? tag}) {
    if (kDebugMode) {
      final logTag = tag ?? _tag;
      debugPrint('$logTag [INFO] $message');
    }
  }

  /// Log warning level messages
  static void warning(String message, {String? tag}) {
    if (kDebugMode) {
      final logTag = tag ?? _tag;
      debugPrint('$logTag [WARNING] $message');
    }
  }

  /// Log error level messages
  static void error(String message, {Exception? exception, StackTrace? stackTrace, String? tag}) {
    if (kDebugMode) {
      final logTag = tag ?? _tag;
      debugPrint('$logTag [ERROR] $message');
      if (exception != null) {
        debugPrint('$logTag Exception: $exception');
      }
      if (stackTrace != null) {
        debugPrint('$logTag StackTrace: $stackTrace');
      }
    }
  }

  /// Log debug level messages
  static void debug(String message, {String? tag}) {
    if (kDebugMode) {
      final logTag = tag ?? _tag;
      debugPrint('$logTag [DEBUG] $message');
    }
  }

  /// Log success level messages
  static void success(String message, {String? tag}) {
    if (kDebugMode) {
      final logTag = tag ?? _tag;
      debugPrint('$logTag [SUCCESS] $message');
    }
  }

  /// Structured logging for API calls
  static void logApiCall({
    required String endpoint,
    required String method,
    Map<String, dynamic>? requestData,
    Map<String, dynamic>? responseData,
    Exception? error,
  }) {
    if (!kDebugMode) {
      return;
    }
    final message = _buildApiMessage(
      endpoint: endpoint,
      method: method,
      requestData: requestData,
      responseData: responseData,
      error: error,
    );
    debugPrint(message);
  }

  static String _buildApiMessage({
    required String endpoint,
    required String method,
    Map<String, dynamic>? requestData,
    Map<String, dynamic>? responseData,
    Exception? error,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('$_tag [API] $method $endpoint');
    _appendLine(buffer, 'Request', requestData);
    _appendLine(buffer, 'Response', responseData);
    _appendLine(buffer, 'Error', error);
    return buffer.toString().trim();
  }

  static void _appendLine(
    StringBuffer buffer,
    String label,
    Object? value,
  ) {
    if (value == null) {
      return;
    }
    buffer.writeln('$label: $value');
  }
}
