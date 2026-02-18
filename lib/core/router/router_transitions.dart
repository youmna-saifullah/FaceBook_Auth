import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Custom page transitions for smooth navigation
class RouterTransitions {
  RouterTransitions._();

  /// Fade transition
  static CustomTransitionPage<dynamic> fadeTransition({
    required Widget child,
    required String name,
  }) {
    return _buildTransition(
      child: child,
      name: name,
      builder: (animation, child) => FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  /// Slide from right transition
  static CustomTransitionPage<dynamic> slideRightTransition({
    required Widget child,
    required String name,
  }) {
    return _slideTransition(
      child: child,
      name: name,
      begin: const Offset(1.0, 0.0),
    );
  }

  /// Slide from left transition
  static CustomTransitionPage<dynamic> slideLeftTransition({
    required Widget child,
    required String name,
  }) {
    return _slideTransition(
      child: child,
      name: name,
      begin: const Offset(-1.0, 0.0),
    );
  }
}

CustomTransitionPage<dynamic> _buildTransition({
  required Widget child,
  required String name,
  required Widget Function(Animation<double>, Widget) builder,
}) {
  return CustomTransitionPage<dynamic>(
    key: ValueKey(name),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return builder(animation, child);
    },
  );
}

CustomTransitionPage<dynamic> _slideTransition({
  required Widget child,
  required String name,
  required Offset begin,
}) {
  final tween = Tween(begin: begin, end: Offset.zero).chain(
    CurveTween(curve: Curves.easeInOut),
  );
  return _buildTransition(
    child: child,
    name: name,
    builder: (animation, child) => SlideTransition(
      position: animation.drive(tween),
      child: child,
    ),
  );
}
