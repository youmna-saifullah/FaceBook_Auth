import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../models/user_model.dart';
import 'auth_local_datasource.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/services/logger/logger_service.dart';

/// Implementation of AuthLocalDataSource using FlutterSecureStorage
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _userKey = 'cached_user';

  final FlutterSecureStorage secureStorage;

  AuthLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      LoggerService.info('Saving user locally: ${user.email}');
      await secureStorage.write(
        key: _userKey,
        value: jsonEncode(user.toJson()),
      );
      LoggerService.success('User saved locally');
    } catch (e) {
      ErrorHandler.logError('Error saving user locally', e);
      rethrow;
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      LoggerService.debug('Retrieving cached user');

      final userJson = await secureStorage.read(key: _userKey);

      if (userJson == null) {
        LoggerService.debug('No cached user found');
        return null;
      }
      final user = UserModel.fromJson(jsonDecode(userJson) as Map<String, dynamic>);

      LoggerService.success('Cached user retrieved: ${user.email}');
      return user;
    } catch (e) {
      ErrorHandler.logError('Error retrieving cached user', e);
      return null;
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      LoggerService.info('Clearing cached user');

      await secureStorage.delete(key: _userKey);

      LoggerService.success('User cache cleared');
    } catch (e) {
      ErrorHandler.logError('Error clearing user cache', e);
      rethrow;
    }
  }

  @override
  Future<bool> isUserCached() async {
    try {
      final userJson = await secureStorage.read(key: _userKey);
      return userJson != null;
    } catch (e) {
      ErrorHandler.logError('Error checking user cache', e);
      return false;
    }
  }
}
