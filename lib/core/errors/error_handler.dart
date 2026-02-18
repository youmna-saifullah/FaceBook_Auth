import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/logger/logger_service.dart';

/// Maps exceptions to user-friendly messages and logs details.
class ErrorHandler {
  ErrorHandler._();

  /// Get a user-friendly message for any error.
  static String getMessage(Object error) {
    if (error is FirebaseAuthException) {
      return _firebaseMessage(error);
    }

    if (error is DioException) {
      return _dioMessage(error);
    }

    if (error is TimeoutException) {
      return 'Request timed out. Please try again.';
    }

    if (error is SocketException) {
      return 'No internet connection.';
    }

    // For generic exceptions, try to extract message
    if (error is Exception) {
      final message = error.toString();
      if (message.contains('Exception:')) {
        return message.replaceAll('Exception: ', '').trim();
      }
      return message.isEmpty ? 'Something went wrong. Please try again.' : message;
    }

    return 'Something went wrong. Please try again.';
  }

  /// Log errors consistently with context.
  static void logError(String context, Object error, [StackTrace? stackTrace]) {
    LoggerService.error(
      context,
      exception: error is Exception ? error : Exception(error.toString()),
      stackTrace: stackTrace,
    );
  }

  static String _firebaseMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'Please enter a valid email.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      default:
        return error.message ?? 'Authentication error.';
    }
  }

  static String _dioMessage(DioException error) {
    final status = error.response?.statusCode;
    if (status == 401 || status == 403) {
      return 'Unauthorized. Please sign in again.';
    }
    if (status != null && status >= 500) {
      return 'Server error. Please try later.';
    }
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Connection timed out. Try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      case DioExceptionType.badResponse:
        return 'Server error. Please try later.';
      default:
        return 'Network error. Please try again.';
    }
  }
}
