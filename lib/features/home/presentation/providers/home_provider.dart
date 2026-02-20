import 'package:flutter/material.dart';

import '../../../../core/enums/load_status.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/services/logger/logger_service.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';

/// Provider for home feature state management.
///
/// Manages home screen specific state and operations.
class HomeProvider extends ChangeNotifier {
  final GetUserProfileUseCase _getUserProfileUseCase;
  final UpdateUserProfileUseCase _updateUserProfileUseCase;

  LoadStatus _status = LoadStatus.idle;
  UserProfileEntity? _userProfile;
  String? _errorMessage;

  HomeProvider({
    required GetUserProfileUseCase getUserProfileUseCase,
    required UpdateUserProfileUseCase updateUserProfileUseCase,
  })  : _getUserProfileUseCase = getUserProfileUseCase,
        _updateUserProfileUseCase = updateUserProfileUseCase;

  /// Current loading status.
  LoadStatus get status => _status;

  /// Current user profile.
  UserProfileEntity? get userProfile => _userProfile;

  /// Current error message, if any.
  String? get errorMessage => _errorMessage;

  /// Clears the current error message.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Loads the user profile.
  Future<void> loadUserProfile() async {
    _status = LoadStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _userProfile = await _getUserProfileUseCase();
      _status = LoadStatus.success;
      LoggerService.info('User profile loaded successfully');
    } catch (error, stackTrace) {
      _status = LoadStatus.error;
      _errorMessage = ErrorHandler.getMessage(error);
      LoggerService.error('Failed to load user profile', exception: error is Exception ? error : Exception(error.toString()), stackTrace: stackTrace);
    } finally {
      notifyListeners();
    }
  }

  /// Updates the user profile.
  Future<void> updateProfile({String? name, String? photoUrl}) async {
    _status = LoadStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _userProfile = await _updateUserProfileUseCase(
        name: name,
        photoUrl: photoUrl,
      );
      _status = LoadStatus.success;
      LoggerService.info('User profile updated successfully');
    } catch (error, stackTrace) {
      _status = LoadStatus.error;
      _errorMessage = ErrorHandler.getMessage(error);
      LoggerService.error('Failed to update user profile', exception: error is Exception ? error : Exception(error.toString()), stackTrace: stackTrace);
    } finally {
      notifyListeners();
    }
  }

  /// Refreshes home screen data.
  Future<void> refresh() async {
    await loadUserProfile();
  }
}
