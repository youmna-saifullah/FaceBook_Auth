import 'package:flutter/material.dart';

class AuthFormLayout extends StatelessWidget {
  final Widget child;

  const AuthFormLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth * 0.08;
            final verticalGap = constraints.maxHeight * 0.02;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalGap * 2,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth * 0.85,
                ),
                child: child,
              ),
            );
          },
        ),
      ),
    );
  }
}
