import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../core/services/dio/dio_client.dart';
import '../core/services/logger/logger_service.dart';
import '../features/home/home_di.dart';
import '../core/services/notifications/firebase_messaging_service.dart';
import '../core/services/notifications/notification_service.dart';
import '../features/auth/data/datasources/auth_local_datasource.dart';
import '../features/auth/data/datasources/auth_local_datasource_impl.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/datasources/auth_remote_datasource_impl.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/facebook_login_usecase.dart';
import '../features/auth/domain/usecases/logout_usecase.dart';
import '../features/auth/domain/usecases/sign_in_usecase.dart';
import '../features/auth/domain/usecases/sign_up_usecase.dart';
import '../features/auth/presentation/providers/auth_provider.dart';

final getIt = GetIt.instance;

void setupInjectionContainer() {
  LoggerService.info('Starting dependency injection setup...');
  _setupCoreServices();
  _setupExternalServices();
  _setupDataSources();
  _setupRepositories();
  _setupUseCases();
  _setupProviders();
  _setupFeatures();
  LoggerService.success('Dependency injection setup completed');
}

void _setupFeatures() {
  setupHomeDI(getIt);
}

void _setupCoreServices() {
  getIt.registerSingleton<Dio>(DioClient().dio);
}

void _setupExternalServices() {
  getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  getIt.registerSingleton<FirebaseMessaging>(FirebaseMessaging.instance);
  getIt.registerSingleton<FacebookAuth>(FacebookAuth.instance);
  getIt.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());
  getIt.registerSingleton<NotificationService>(NotificationService());
  getIt.registerSingleton<FirebaseMessagingService>(
    FirebaseMessagingService(
      getIt<FirebaseMessaging>(),
      getIt<NotificationService>(),
    ),
  );
}

void _setupDataSources() {
  getIt.registerSingleton<AuthRemoteDataSource>(
    AuthRemoteDataSourceImpl(
      firebaseAuth: getIt<FirebaseAuth>(),
      facebookAuth: getIt<FacebookAuth>(),
    ),
  );
  getIt.registerSingleton<AuthLocalDataSource>(
    AuthLocalDataSourceImpl(
      secureStorage: getIt<FlutterSecureStorage>(),
    ),
  );
}

void _setupRepositories() {
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
    ),
  );
}

void _setupUseCases() {
  getIt.registerSingleton<SignInUseCase>(SignInUseCase(getIt<AuthRepository>()));
  getIt.registerSingleton<SignUpUseCase>(SignUpUseCase(getIt<AuthRepository>()));
  getIt.registerSingleton<FacebookLoginUseCase>(
    FacebookLoginUseCase(getIt<AuthRepository>()),
  );
  getIt.registerSingleton<LogoutUseCase>(LogoutUseCase(getIt<AuthRepository>()));
}

void _setupProviders() {
  getIt.registerSingleton<AuthProvider>(
    AuthProvider(
      signInUseCase: getIt<SignInUseCase>(),
      signUpUseCase: getIt<SignUpUseCase>(),
      facebookLoginUseCase: getIt<FacebookLoginUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
    ),
  );
}
