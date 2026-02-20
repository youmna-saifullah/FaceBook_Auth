import '../entities/user_profile_entity.dart';
import '../repositories/home_repository.dart';

/// Use case for updating the current user's profile.
/// 
/// Updates user profile data via the repository.
class UpdateUserProfileUseCase {
  final HomeRepository _repository;

  UpdateUserProfileUseCase(this._repository);

  /// Executes the use case.
  /// 
  /// [name] - Optional new display name.
  /// [photoUrl] - Optional new photo URL.
  /// 
  /// Returns updated [UserProfileEntity] on success.
  /// Throws exception on failure.
  Future<UserProfileEntity> call({
    String? name,
    String? photoUrl,
  }) async {
    return await _repository.updateUserProfile(
      name: name,
      photoUrl: photoUrl,
    );
  }
}
