import '../entities/user_profile_entity.dart';
import '../repositories/home_repository.dart';

/// Use case for retrieving the current user's profile.
/// 
/// Fetches user profile data from the repository.
class GetUserProfileUseCase {
  final HomeRepository _repository;

  GetUserProfileUseCase(this._repository);

  /// Executes the use case.
  /// 
  /// Returns [UserProfileEntity] on success.
  /// Throws exception on failure.
  Future<UserProfileEntity> call() async {
    return await _repository.getUserProfile();
  }
}
