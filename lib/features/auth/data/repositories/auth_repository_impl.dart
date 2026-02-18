import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';
import '../datasources/auth_local_datasource.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/services/logger/logger_service.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) async {
    return _executeAndCache(
      () => remoteDataSource.signIn(email: email, password: password),
      'Repo: sign in failed',
    );
  }

  @override
  Future<UserEntity> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    return _executeAndCache(
      () => remoteDataSource.signUp(
        name: name,
        email: email,
        password: password,
      ),
      'Repo: sign up failed',
    );
  }

  @override
  Future<UserEntity> loginWithFacebook() async {
    return _executeAndCache(
      () => remoteDataSource.loginWithFacebook(),
      'Repo: Facebook login failed',
    );
  }

  @override
  Future<void> logout() async {
    try {
      LoggerService.info('Repo: logout');
      await remoteDataSource.logout();
      await localDataSource.clearUser();
    } catch (e, stackTrace) {
      ErrorHandler.logError('Repo: logout failed', e, stackTrace);
      throw Exception(ErrorHandler.getMessage(e));
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final remote = await remoteDataSource.getCurrentUser();
    if (remote != null) {
      await localDataSource.saveUser(remote);
      return remote;
    }
    return localDataSource.getCachedUser();
  }

  Future<UserEntity> _executeAndCache(
    Future<UserModel> Function() action,
    String logMessage,
  ) async {
    try {
      final user = await action();
      await localDataSource.saveUser(user);
      return user;
    } catch (e, stackTrace) {
      ErrorHandler.logError(logMessage, e, stackTrace);
      throw Exception(ErrorHandler.getMessage(e));
    }
  }
}
