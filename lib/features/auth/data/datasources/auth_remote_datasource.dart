import '../models/user_model.dart';

/// Abstract interface for remote authentication data source
abstract class AuthRemoteDataSource {
  /// Sign in with email and password
  Future<UserModel> signIn({
    required String email,
    required String password,
  });

  /// Sign up with email, password, and name
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  });

  /// Login with Facebook
  Future<UserModel> loginWithFacebook();

  /// Logout
  Future<void> logout();

  /// Get current user
  Future<UserModel?> getCurrentUser();
}
