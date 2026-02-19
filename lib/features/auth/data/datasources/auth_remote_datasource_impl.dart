import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/services/logger/logger_service.dart';

/// Implementation of AuthRemoteDataSource using Firebase
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FacebookAuth facebookAuth;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.facebookAuth,
  });

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    return _runAuthAction(() async {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _userFromCredential(credential);
    }, context: 'Email sign in');
  }

  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    return _runAuthAction(() async {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _updateDisplayName(credential, name);
      return _userFromCredential(credential, nameOverride: name);
    }, context: 'Email sign up');
  }

  @override
  Future<UserModel> loginWithFacebook() async {
    try {
      LoggerService.info('Facebook login: Starting login flow');
      final result = await facebookAuth.login(
        permissions: ['email', 'public_profile'],
      );
      LoggerService.info('Facebook login: Login result status = ${result.status}');
      
      final token = result.accessToken?.tokenString;
      if (token?.isEmpty ?? true) {
        throw Exception(
          'Facebook authentication failed (status: ${result.status}). Please try again.',
        );
      }
      
      LoggerService.info('Facebook login: Got access token, signing in with Firebase');
      final credential = FacebookAuthProvider.credential(token!);
      final userCredential = await firebaseAuth.signInWithCredential(credential);
      LoggerService.success('Facebook login: Firebase sign in successful');
      
      LoggerService.info('Facebook login: Fetching profile data');
      final profile = await _fetchFacebookProfile();
      LoggerService.success('Facebook login: Profile fetched successfully');
      
      return _userFromCredential(
        userCredential,
        nameOverride: profile.name,
        emailOverride: profile.email,
        photoUrlOverride: profile.photoUrl,
      );
    } catch (error, stackTrace) {
      ErrorHandler.logError('Facebook login', error, stackTrace);
      throw Exception('Facebook login failed. Please check your Facebook app configuration on Android or try again.');
    }
  }

  @override
  Future<void> logout() async {
    await _runAuthAction(() async {
      await Future.wait([
        firebaseAuth.signOut(),
        facebookAuth.logOut(),
      ]);
    }, context: 'Logout');
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        return null;
      }
      return UserModel.fromAuthData(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName,
        photoUrl: user.photoURL,
      );
    } catch (error, stackTrace) {
      ErrorHandler.logError('Get current user', error, stackTrace);
      return null;
    }
  }

  Future<T> _runAuthAction<T>(
    Future<T> Function() action, {
    required String context,
  }) async {
    try {
      LoggerService.info('$context started');
      final result = await action();
      LoggerService.success('$context successful');
      return result;
    } catch (error, stackTrace) {
      ErrorHandler.logError(context, error, stackTrace);
      throw Exception(ErrorHandler.getMessage(error));
    }
  }

  Future<void> _updateDisplayName(UserCredential credential, String name) async {
    final user = credential.user;
    if (user == null || name.isEmpty) {
      return;
    }
    await user.updateDisplayName(name);
    await user.reload();
  }

  UserModel _userFromCredential(
    UserCredential credential, {
    String? nameOverride,
    String? emailOverride,
    String? photoUrlOverride,
  }) {
    final user = credential.user;
    if (user == null) {
      throw Exception('Authentication failed.');
    }
    return UserModel.fromAuthData(
      id: user.uid,
      email: emailOverride ?? user.email ?? '',
      name: nameOverride ?? user.displayName,
      photoUrl: photoUrlOverride ?? user.photoURL,
    );
  }

  Future<_FacebookProfile> _fetchFacebookProfile() async {
    try {
      LoggerService.info('Fetching Facebook profile data');
      final data = await facebookAuth.getUserData(
        fields: 'name,email,picture.width(200)',
      );
      LoggerService.info('Facebook profile data: $data');
      return _FacebookProfile.fromMap(data);
    } catch (error) {
      LoggerService.warning('Failed to fetch Facebook profile, proceeding without profile data');
      return const _FacebookProfile();
    }
  }
}

class _FacebookProfile {
  final String? name;
  final String? email;
  final String? photoUrl;

  const _FacebookProfile({
    this.name,
    this.email,
    this.photoUrl,
  });

  factory _FacebookProfile.fromMap(Map<String, dynamic> data) {
    final picture = data['picture'] as Map<String, dynamic>?;
    final pictureData = picture?['data'] as Map<String, dynamic>?;
    return _FacebookProfile(
      name: data['name'] as String?,
      email: data['email'] as String?,
      photoUrl: pictureData?['url'] as String?,
    );
  }
}
