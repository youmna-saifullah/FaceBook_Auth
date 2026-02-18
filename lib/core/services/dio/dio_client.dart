import 'package:dio/dio.dart';
import '../logger/logger_service.dart';

/// Dio HTTP client configuration and setup
class DioClient {
  final Dio dio;

  DioClient({Dio? dio}) : dio = dio ?? _createDio() {
    this.dio.interceptors.add(_LoggingInterceptor());
    this.dio.interceptors.add(_ErrorInterceptor());
  }
}

Dio _createDio() {
  return Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      contentType: 'application/json',
      responseType: ResponseType.json,
    ),
  );
}

/// Logging interceptor for Dio requests
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    LoggerService.logApiCall(
      endpoint: options.path,
      method: options.method,
      requestData: options.data is Map ? options.data as Map<String, dynamic> : null,
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    LoggerService.logApiCall(
      endpoint: response.requestOptions.path,
      method: response.requestOptions.method,
      responseData: response.data is Map ? response.data as Map<String, dynamic> : null,
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    LoggerService.error(
      'API Error: ${err.message}',
      exception: Exception(err),
    );
    handler.next(err);
  }
}

/// Error interceptor for handling Dio exceptions
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage = _getErrorMessage(err);
    LoggerService.error(
      'Network Error: $errorMessage',
      exception: Exception(err),
      stackTrace: err.stackTrace,
    );
    handler.next(err);
  }

  String _getErrorMessage(DioException error) {
    switch (error.type) {
      case DioExceptionType.badResponse:
        return 'Bad Response: ${error.response?.statusCode}';
      case DioExceptionType.connectionTimeout:
        return 'Connection Timeout';
      case DioExceptionType.receiveTimeout:
        return 'Receive Timeout';
      case DioExceptionType.sendTimeout:
        return 'Send Timeout';
      case DioExceptionType.unknown:
        return error.message ?? 'Unknown Error';
      default:
        return 'Network Error';
    }
  }
}
