import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/enums/load_status.dart';
import '../../../../core/router/router_name.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final provider = context.watch<AuthProvider>();
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
    final padding = constraints.maxWidth * 0.08;
    final gap = constraints.maxHeight * 0.02;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding, vertical: gap * 2),
      child: Column(
        children: [
          _buildProfileCard(context, provider, constraints),
          SizedBox(height: gap * 2),
          _buildLogoutButton(context, provider),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, AuthProvider provider, BoxConstraints constraints) {
    final user = provider.user;
    final gap = constraints.maxHeight * 0.015;
    return Center(
      child: SizedBox(
        width: constraints.maxWidth * 0.85,
        child: Card(
          elevation: 6,
          child: Padding(
            padding: EdgeInsets.all(constraints.maxWidth * 0.05),
            child: Column(
              children: [
                _buildAvatar(user?.photoUrl, constraints),
                SizedBox(height: gap),
                _buildNameText(user?.name, context),
                SizedBox(height: gap * 0.5),
                _buildEmailText(user?.email, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(String? photoUrl, BoxConstraints constraints) {
    final radius = constraints.maxWidth * 0.08;
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primary.withOpacity(0.1),
      backgroundImage: photoUrl == null || photoUrl.isEmpty
          ? null
          : NetworkImage(photoUrl),
      child: photoUrl == null || photoUrl.isEmpty
          ? Icon(Icons.person, size: radius, color: AppColors.primary)
          : null,
    );
  }

  Widget _buildNameText(String? name, BuildContext context) {
    return Text(name ?? 'No Name', style: Theme.of(context).textTheme.titleLarge);
  }

  Widget _buildEmailText(String? email, BuildContext context) {
    return Text(email ?? 'No Email', style: Theme.of(context).textTheme.bodyMedium);
  }

  Widget _buildLogoutButton(BuildContext context, AuthProvider provider) {
    final isLoading = provider.status == LoadStatus.loading;
    return ElevatedButton(
      onPressed: isLoading ? null : () => _onLogout(context, provider),
      child: isLoading ? _buildLoader(context) : const Text('Logout'),
    );
  }

  Widget _buildLoader(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 0.05;
    return SizedBox(
      height: size,
      width: size,
      child: const CircularProgressIndicator(strokeWidth: 2),
    );
  }

  Future<void> _onLogout(BuildContext context, AuthProvider provider) async {
    await provider.logout();
    if (provider.status == LoadStatus.success) {
      _showSnack(context, 'Logged out successfully');
      context.go(RouteName.signin);
    }
  }

  void _showSnack(BuildContext context, String message) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    });
  }
}
