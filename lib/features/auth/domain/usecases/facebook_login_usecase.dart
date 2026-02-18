import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for Facebook login
class FacebookLoginUseCase {
  final AuthRepository repository;

  FacebookLoginUseCase(this.repository);

  Future<UserEntity> call() {
    return repository.loginWithFacebook();
  }
}
