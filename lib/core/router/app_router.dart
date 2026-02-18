import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/injection_container.dart';
import '../../core/services/logger/logger_service.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/home_screen.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import 'router_name.dart';
import 'router_transitions.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RouteName.signin,
    refreshListenable: getIt<AuthProvider>(),
    redirect: _redirect,
    routes: [
      GoRoute(
        path: RouteName.signin,
        name: 'signin',
        pageBuilder: (context, state) => RouterTransitions.slideRightTransition(
          child: const SignInScreen(),
          name: RouteName.signin,
        ),
      ),
      GoRoute(
        path: RouteName.signup,
        name: 'signup',
        pageBuilder: (context, state) => RouterTransitions.slideLeftTransition(
          child: const SignUpScreen(),
          name: RouteName.signup,
        ),
      ),
      GoRoute(
        path: RouteName.home,
        name: 'home',
        pageBuilder: (context, state) => RouterTransitions.fadeTransition(
          child: const HomeScreen(),
          name: RouteName.home,
        ),
      ),
    ],
  );
}

String? _redirect(BuildContext context, GoRouterState state) {
  final authProvider = getIt<AuthProvider>();
  final isAuthenticated = authProvider.isAuthenticated;
  final path = state.uri.path;
  LoggerService.debug('Router redirect: path=$path, auth=$isAuthenticated');
  if (!_isAuthRoute(path) && !isAuthenticated) {
    return RouteName.signin;
  }
  if (_isAuthRoute(path) && isAuthenticated) {
    return RouteName.home;
  }
  return null;
}

bool _isAuthRoute(String path) {
  return path == RouteName.signin || path == RouteName.signup;
}
