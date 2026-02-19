import 'package:facebook_auth/core/enums/load_status.dart';
import 'package:facebook_auth/core/errors/error_handler.dart';
import 'package:facebook_auth/core/services/logger/logger_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/facebook_login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/sign_up_usecase.dart';

class AuthProvider extends ChangeNotifier {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final FacebookLoginUseCase facebookLoginUseCase;
  final LogoutUseCase logoutUseCase;

  LoadStatus _status = LoadStatus.idle;
  UserEntity? _user;
  String? _errorMessage;
  bool _successAnimation = false;
  String _signInEmail = '';
  String _signInPassword = '';
  String _signUpName = '';
  String _signUpEmail = '';
  String _signUpPassword = '';

  AuthProvider({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.facebookLoginUseCase,
    required this.logoutUseCase,
  });

  LoadStatus get status => _status;
  UserEntity? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get shouldAnimateSuccess => _successAnimation;
  bool get isAuthenticated => _user != null;

  void consumeSuccessAnimation() {
    _successAnimation = false;
  }

  void consumeError() {
    _errorMessage = null;
  }

  void setSignUpName(String value) {
    _signUpName = value.trim();
  }

  void setSignInEmail(String value) {
    _signInEmail = value.trim();
  }

  void setSignInPassword(String value) {
    _signInPassword = value.trim();
  }

  String? validateRequired(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required';
    }
    return null;
  }

  Future<void> submitSignInForm(GlobalKey<FormState> formKey) async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }
    await signIn(email: _signInEmail, password: _signInPassword);
  }

  void setSignUpEmail(String value) {
    _signUpEmail = value.trim();
  }

  void setSignUpPassword(String value) {
    _signUpPassword = value.trim();
  }

  String? validateSignUpConfirmPassword(String? value) {
    final confirm = value?.trim() ?? '';
    if (confirm.isEmpty) {
      return 'Confirm password is required';
    }
    if (confirm != _signUpPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> submitSignUpForm(GlobalKey<FormState> formKey) async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }
    await signUp(
      name: _signUpName,
      email: _signUpEmail,
      password: _signUpPassword,
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _runAuthAction(
      () => signInUseCase(email: email, password: password),
      'Sign in',
    );
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await _runAuthAction(
      () => signUpUseCase(name: name, email: email, password: password),
      'Sign up',
    );
  }

  Future<void> loginWithFacebook() async {
    await _runAuthAction(facebookLoginUseCase.call, 'Facebook login');
  }

  Future<void> logout() async {
    _status = LoadStatus.loading;
    try {
      await logoutUseCase();
      _user = null;
      _successAnimation = false;
      _status = LoadStatus.success;
    } catch (error, stackTrace) {
      _handleError('Logout failed', error, stackTrace);
    } finally {
      notifyListeners();
    }
  }

  Future<void> _runAuthAction(
    Future<UserEntity> Function() action,
    String context,
  ) async {
    _status = LoadStatus.loading;
    _errorMessage = null;
    try {
      _handleSuccess(await action(), context);
    } catch (error, stackTrace) {
      _handleError('$context failed', error, stackTrace);
    } finally {
      notifyListeners();
    }
  }

  void _handleSuccess(UserEntity user, String context) {
    LoggerService.success('$context successful');
    _user = user;
    _successAnimation = true;
    _status = LoadStatus.success;
  }

  void _handleError(String context, Object error, StackTrace stackTrace) {
    ErrorHandler.logError(context, error, stackTrace);
    _errorMessage = ErrorHandler.getMessage(error);
    _successAnimation = false;
    _status = LoadStatus.error;
  }
}
