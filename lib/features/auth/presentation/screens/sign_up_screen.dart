import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/enums/load_status.dart';
import '../../../../core/router/router_name.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_action_button.dart';
import '../widgets/auth_form_layout.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();
    _handleState(context, provider);
    return AuthFormLayout(child: _buildForm(context, provider));
  }

  Widget _buildForm(BuildContext context, AuthProvider provider) {
    final verticalGap = MediaQuery.of(context).size.height * 0.02;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context, verticalGap),
          _buildNameField(context),
          SizedBox(height: verticalGap),
          _buildEmailField(context),
          SizedBox(height: verticalGap),
          _buildPasswordField(context),
          SizedBox(height: verticalGap),
          _buildConfirmField(context),
          SizedBox(height: verticalGap * 1.5),
          _buildPrimaryButton(provider),
          SizedBox(height: verticalGap),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double verticalGap) {
    return Padding(
      padding: EdgeInsets.only(bottom: verticalGap * 2),
      child: Text(
        'Create Account',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  Widget _buildNameField(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Name'),
      onChanged: context.read<AuthProvider>().setSignUpName,
      validator: (value) =>
          context.read<AuthProvider>().validateRequired(value, 'Name'),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(labelText: 'Email'),
      onChanged: context.read<AuthProvider>().setSignUpEmail,
      validator: (value) =>
          context.read<AuthProvider>().validateRequired(value, 'Email'),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return TextFormField(
      obscureText: true,
      decoration: const InputDecoration(labelText: 'Password'),
      onChanged: context.read<AuthProvider>().setSignUpPassword,
      validator: (value) =>
          context.read<AuthProvider>().validateRequired(value, 'Password'),
    );
  }

  Widget _buildConfirmField(BuildContext context) {
    return TextFormField(
      obscureText: true,
      decoration: const InputDecoration(labelText: 'Confirm Password'),
      validator: context.read<AuthProvider>().validateSignUpConfirmPassword,
    );
  }

  Widget _buildPrimaryButton(AuthProvider provider) {
    return AuthActionButton(
      label: 'Sign Up',
      isLoading: provider.status == LoadStatus.loading,
      color: provider.shouldAnimateSuccess
          ? AppColors.secondary
          : AppColors.primary,
      onPressed: provider.status == LoadStatus.loading
          ? null
          : () => provider.submitSignUpForm(_formKey),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return TextButton(
      onPressed: () => context.go(RouteName.signin),
      child: const Text('Already have an account? Sign in'),
    );
  }

  void _handleState(BuildContext context, AuthProvider provider) {
    if (provider.status == LoadStatus.success &&
        provider.user != null &&
        provider.shouldAnimateSuccess) {
      _postFrame(() {
        _showSnack(context, 'Successfully Registered');
        provider.consumeSuccessAnimation();
        context.go(RouteName.home);
      });
    }
    if (provider.status == LoadStatus.error) {
      final message = provider.errorMessage;
      if (message != null) {
        _postFrame(() {
          _showSnack(context, message);
          provider.consumeError();
        });
      }
    }
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _postFrame(VoidCallback action) {
    WidgetsBinding.instance.addPostFrameCallback((_) => action());
  }
}
