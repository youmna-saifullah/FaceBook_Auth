# Home Feature

## Overview
Displays user profile information and provides logout functionality after successful authentication.

## Layers

### Presentation Layer
- **Screens**: `HomeScreen` - Main screen showing user profile and logout button.
- **Providers**: `HomeProvider` - State management for profile loading and updates.
- **Widgets**: `ProfileCard` - Reusable profile display component.

### Domain Layer
- **Entities**: `UserProfileEntity` - User profile data structure.
- **Repositories**: `HomeRepository` - Abstract repository contract.
- **UseCases**: 
  - `GetUserProfileUseCase` - Fetches user profile.
  - `UpdateUserProfileUseCase` - Updates user profile.

### Data Layer
- **DataSources**: 
  - `HomeRemoteDataSource` - Firebase user profile operations.
  - `HomeLocalDataSource` - Secure storage caching.
- **Models**: `UserProfileModel` - Data transfer object with JSON serialization.
- **Repositories**: `HomeRepositoryImpl` - Repository implementation.

## Data Flow
```
UI (HomeScreen) 
  -> Provider (HomeProvider) 
    -> UseCase (GetUserProfileUseCase) 
      -> Repository (HomeRepositoryImpl) 
        -> DataSource (HomeRemoteDataSource/HomeLocalDataSource) 
          -> Firebase/SecureStorage
```

## Dependencies
- Uses `AuthProvider` from the auth feature for logout functionality.
- Registered in [lib/app/injection_container.dart](../../app/injection_container.dart).

## Dependency Injection
Home-specific dependencies are registered in [home_di.dart](home_di.dart).
