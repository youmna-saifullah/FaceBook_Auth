import '../entities/user_profile_entity.dart';

/// Abstract repository contract for home feature operations.
/// 
/// Defines the interface for user profile data operations.
abstract class HomeRepository {
  /// Retrieves the current user's profile.
  /// 
  /// Returns [UserProfileEntity] if profile exists.
  /// Throws exception on failure.
  Future<UserProfileEntity> getUserProfile();

  /// Updates the user's profile information.
  /// 
  /// Returns updated [UserProfileEntity] on success.
  /// Throws exception on failure.
  Future<UserProfileEntity> updateUserProfile({
    String? name,
    String? photoUrl,
  });

  /// Clears locally cached profile data.
  Future<void> clearProfileCache();
}
