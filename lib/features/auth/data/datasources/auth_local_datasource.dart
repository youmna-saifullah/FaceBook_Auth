import '../models/user_model.dart';

/// Abstract interface for local authentication data source
abstract class AuthLocalDataSource {
  /// Save user locally
  Future<void> saveUser(UserModel user);

  /// Get cached user
  Future<UserModel?> getCachedUser();

  /// Clear user data
  Future<void> clearUser();

  /// Check if user is cached
  Future<bool> isUserCached();
}
