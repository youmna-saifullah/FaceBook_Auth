import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/user_profile_entity.dart';

/// A card widget displaying user profile information.
class ProfileCard extends StatelessWidget {
  /// The user profile entity to display.
  final UserProfileEntity? user;

  /// Layout constraints for responsive sizing.
  final BoxConstraints constraints;

  const ProfileCard({
    super.key,
    required this.user,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
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
                _buildAvatar(),
                SizedBox(height: gap),
                _buildNameText(context),
                SizedBox(height: gap * 0.5),
                _buildEmailText(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final photoUrl = user?.photoUrl;
    final radius = constraints.maxWidth * 0.08;
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
      backgroundImage:
          photoUrl == null || photoUrl.isEmpty ? null : NetworkImage(photoUrl),
      child: photoUrl == null || photoUrl.isEmpty
          ? Icon(Icons.person, size: radius, color: AppColors.primary)
          : null,
    );
  }

  Widget _buildNameText(BuildContext context) {
    return Text(
      user?.name ?? 'No Name',
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  Widget _buildEmailText(BuildContext context) {
    return Text(
      user?.email ?? 'No Email',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
