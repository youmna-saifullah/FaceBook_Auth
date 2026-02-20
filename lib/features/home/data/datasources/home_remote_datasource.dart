import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/services/logger/logger_service.dart';
import '../models/user_profile_model.dart';

abstract class HomeRemoteDataSource {
  /// Fetches current user profile from Firebase.
  Future<UserProfileModel> getUserProfile();

  /// Updates user profile in Firebase.
  Future<UserProfileModel> updateUserProfile({
    String? name,
    String? photoUrl,
  });
}

/// Implementation of [HomeRemoteDataSource] using Firebase.
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  HomeRemoteDataSourceImpl({
    required FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth;

  @override
  Future<UserProfileModel> getUserProfile() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      LoggerService.debug('Fetched user profile from Firebase');
      return UserProfileModel(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName,
        photoUrl: user.photoURL,
        lastLoginAt: user.metadata.lastSignInTime,
      );
    } catch (error, stackTrace) {
      LoggerService.error('Failed to get user profile', exception: error is Exception ? error : Exception(error.toString()), stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<UserProfileModel> updateUserProfile({
    String? name,
    String? photoUrl,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      if (name != null) {
        await user.updateDisplayName(name);
      }
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }

      // Reload user to get updated data
      await user.reload();
      final updatedUser = _firebaseAuth.currentUser!;

      LoggerService.info('Updated user profile');
      return UserProfileModel(
        id: updatedUser.uid,
        email: updatedUser.email ?? '',
        name: updatedUser.displayName,
        photoUrl: updatedUser.photoURL,
        lastLoginAt: updatedUser.metadata.lastSignInTime,
      );
    } catch (error, stackTrace) {
      LoggerService.error('Failed to update user profile', exception: error is Exception ? error : Exception(error.toString()), stackTrace: stackTrace);
      rethrow;
    }
  }
}
