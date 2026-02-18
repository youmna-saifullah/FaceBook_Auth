import '../entities/user_entity.dart';

/// Abstract repository for authentication
abstract class AuthRepository {
  /// Sign in with email and password
  Future<UserEntity> signIn({
    required String email,
    required String password,
  });

  /// Sign up with name, email, and password
  Future<UserEntity> signUp({
    required String name,
    required String email,
    required String password,
  });

  /// Login with Facebook
  Future<UserEntity> loginWithFacebook();

  /// Logout
  Future<void> logout();

  /// Get cached or current user
  Future<UserEntity?> getCurrentUser();
}
