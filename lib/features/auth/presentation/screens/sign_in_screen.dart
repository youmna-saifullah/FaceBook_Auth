import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/enums/load_status.dart';
import '../../../../core/router/router_name.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_action_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _primaryPressed = false;
  bool _facebookPressed = false;
  LoadStatus _lastStatus = LoadStatus.idle;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final provider = context.watch<AuthProvider>();
            _handleState(context, provider);
            return _buildContent(context, constraints, provider);
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    BoxConstraints constraints,
    AuthProvider provider,
  ) {
    final horizontalPadding = constraints.maxWidth * 0.08;
    final verticalGap = constraints.maxHeight * 0.02;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalGap * 2,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.85),
        child: _buildForm(context, verticalGap, provider),
      ),
    );
  }

  Widget _buildForm(
    BuildContext context,
    double verticalGap,
    AuthProvider provider,
  ) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context, verticalGap),
          _buildEmailField(),
          SizedBox(height: verticalGap),
          _buildPasswordField(),
          SizedBox(height: verticalGap * 1.5),
          _buildPrimaryButton(provider),
          SizedBox(height: verticalGap),
          _buildFacebookButton(provider),
          SizedBox(height: verticalGap),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, double verticalGap) {
    final style = Theme.of(context).textTheme.headlineSmall;
    return Padding(
      padding: EdgeInsets.only(bottom: verticalGap * 2),
      child: Text(
        'Welcome Back',
        style: style,
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(labelText: 'Email'),
      validator: (value) => _requiredValidator(value, 'Email'),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: const InputDecoration(labelText: 'Password'),
      validator: (value) => _requiredValidator(value, 'Password'),
    );
  }

  Widget _buildPrimaryButton(AuthProvider provider) {
    final isLoading = provider.status == LoadStatus.loading;
    final success = provider.shouldAnimateSuccess;
    final color = success ? AppColors.secondary : AppColors.primary;
    return AuthActionButton(
      label: 'Sign In',
      isLoading: isLoading,
      isPressed: _primaryPressed,
      color: color,
      onPressed: isLoading ? null : () => _onSignIn(provider),
      onPressState: (value) => setState(() => _primaryPressed = value),
    );
  }

  Widget _buildFacebookButton(AuthProvider provider) {
    final isLoading = provider.status == LoadStatus.loading;
    final success = provider.shouldAnimateSuccess;
    final color = success ? AppColors.secondary : AppColors.primary;
    return AuthActionButton(
      label: 'Continue with Facebook',
      isLoading: isLoading,
      isPressed: _facebookPressed,
      color: color,
      isOutlined: true,
      onPressed: isLoading ? null : () => _onFacebookLogin(provider),
      onPressState: (value) => setState(() => _facebookPressed = value),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return TextButton(
      onPressed: () => context.go(RouteName.signup),
      child: const Text('New here? Create an account'),
    );
  }

  String? _requiredValidator(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label is required';
    }
    return null;
  }

  Future<void> _onSignIn(AuthProvider provider) async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }
    await provider.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  Future<void> _onFacebookLogin(AuthProvider provider) async {
    await provider.loginWithFacebook();
  }

  void _handleState(BuildContext context, AuthProvider provider) {
    if (_lastStatus == provider.status) {
      return;
    }
    _lastStatus = provider.status;
    if (provider.status == LoadStatus.success && provider.user != null) {
      _postFrame(() {
        _showSnack(context, 'Successfully Logged In');
        provider.consumeSuccessAnimation();
        context.go(RouteName.home);
      });
    }
    if (provider.status == LoadStatus.error && provider.errorMessage != null) {
      final message = provider.errorMessage;
      if (message != null) {
        _postFrame(() => _showSnack(context, message));
      }
    }
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _postFrame(VoidCallback action) {
    WidgetsBinding.instance.addPostFrameCallback((_) => action());
  }
}
