import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'data/datasources/home_local_datasource.dart';
import 'data/datasources/home_local_datasource_impl.dart';
import 'data/datasources/home_remote_datasource.dart';
import 'data/repositories/home_repository_impl.dart';
import 'domain/repositories/home_repository.dart';
import 'domain/usecases/get_user_profile_usecase.dart';
import 'domain/usecases/update_user_profile_usecase.dart';
import 'presentation/providers/home_provider.dart';

/// Sets up dependency injection for the Home feature.
void setupHomeDI(GetIt getIt) {
  // Data Sources
  getIt.registerSingleton<HomeRemoteDataSource>(
    HomeRemoteDataSourceImpl(
      firebaseAuth: getIt<FirebaseAuth>(),
    ),
  );
  getIt.registerSingleton<HomeLocalDataSource>(
    HomeLocalDataSourceImpl(
      secureStorage: getIt<FlutterSecureStorage>(),
    ),
  );

  // Repositories
  getIt.registerSingleton<HomeRepository>(
    HomeRepositoryImpl(
      remoteDataSource: getIt<HomeRemoteDataSource>(),
      localDataSource: getIt<HomeLocalDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerSingleton<GetUserProfileUseCase>(
    GetUserProfileUseCase(getIt<HomeRepository>()),
  );
  getIt.registerSingleton<UpdateUserProfileUseCase>(
    UpdateUserProfileUseCase(getIt<HomeRepository>()),
  );

  // Providers
  getIt.registerSingleton<HomeProvider>(
    HomeProvider(
      getUserProfileUseCase: getIt<GetUserProfileUseCase>(),
      updateUserProfileUseCase: getIt<UpdateUserProfileUseCase>(),
    ),
  );
}
