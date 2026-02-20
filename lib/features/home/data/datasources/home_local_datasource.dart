import '../models/user_profile_model.dart';

/// Abstract data source for home feature local operations.
/// 
/// Handles caching and retrieval of user profile from local storage.
abstract class HomeLocalDataSource {
  /// Retrieves cached user profile.
  /// 
  /// Returns [UserProfileModel] if cached, null otherwise.
  Future<UserProfileModel?> getCachedProfile();

  /// Caches user profile locally.
  Future<void> cacheProfile(UserProfileModel profile);

  /// Clears cached profile data.
  Future<void> clearCache();
}
