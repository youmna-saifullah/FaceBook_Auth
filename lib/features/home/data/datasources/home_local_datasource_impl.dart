import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/services/logger/logger_service.dart';
import '../models/user_profile_model.dart';
import 'home_local_datasource.dart';

/// Implementation of [HomeLocalDataSource] using secure storage.
class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final FlutterSecureStorage _secureStorage;

  static const String _profileKey = 'cached_user_profile';

  HomeLocalDataSourceImpl({
    required FlutterSecureStorage secureStorage,
  }) : _secureStorage = secureStorage;

  @override
  Future<UserProfileModel?> getCachedProfile() async {
    try {
      final jsonString = await _secureStorage.read(key: _profileKey);
      if (jsonString == null) return null;

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      LoggerService.debug('Retrieved cached profile');
      return UserProfileModel.fromJson(json);
    } catch (error, stackTrace) {
      LoggerService.error('Failed to get cached profile', exception: error is Exception ? error : Exception(error.toString()), stackTrace: stackTrace);
      return null;
    }
  }

  @override
  Future<void> cacheProfile(UserProfileModel profile) async {
    try {
      final jsonString = jsonEncode(profile.toJson());
      await _secureStorage.write(key: _profileKey, value: jsonString);
      LoggerService.debug('Cached user profile');
    } catch (error, stackTrace) {
      LoggerService.error('Failed to cache profile', exception: error is Exception ? error : Exception(error.toString()), stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _secureStorage.delete(key: _profileKey);
      LoggerService.debug('Cleared profile cache');
    } catch (error, stackTrace) {
      LoggerService.error('Failed to clear profile cache', exception: error is Exception ? error : Exception(error.toString()), stackTrace: stackTrace);
      rethrow;
    }
  }
}
