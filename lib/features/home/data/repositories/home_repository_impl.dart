import '../../../../core/services/logger/logger_service.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_datasource.dart';
import '../datasources/home_remote_datasource.dart';

/// Implementation of [HomeRepository].
/// 
/// Coordinates between remote and local data sources for user profile operations.
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;
  final HomeLocalDataSource _localDataSource;

  HomeRepositoryImpl({
    required HomeRemoteDataSource remoteDataSource,
    required HomeLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<UserProfileEntity> getUserProfile() async {
    try {
      // Try to get from remote source
      final profile = await _remoteDataSource.getUserProfile();

      // Cache the profile
      await _localDataSource.cacheProfile(profile);

      LoggerService.debug('Retrieved and cached user profile');
      return profile.toEntity();
    } catch (error, stackTrace) {
      LoggerService.warning('Remote fetch failed, trying cache');

      // Fallback to cached profile
      final cachedProfile = await _localDataSource.getCachedProfile();
      if (cachedProfile != null) {
        return cachedProfile.toEntity();
      }

      LoggerService.error('Failed to get user profile', exception: error is Exception ? error : Exception(error.toString()), stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<UserProfileEntity> updateUserProfile({
    String? name,
    String? photoUrl,
  }) async {
    try {
      final updatedProfile = await _remoteDataSource.updateUserProfile(
        name: name,
        photoUrl: photoUrl,
      );

      // Update cache
      await _localDataSource.cacheProfile(updatedProfile);

      LoggerService.info('Profile updated successfully');
      return updatedProfile.toEntity();
    } catch (error, stackTrace) {
      LoggerService.error('Failed to update profile', exception: error is Exception ? error : Exception(error.toString()), stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> clearProfileCache() async {
    await _localDataSource.clearCache();
    LoggerService.debug('Profile cache cleared');
  }
}
