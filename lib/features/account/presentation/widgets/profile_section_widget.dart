import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';
import 'package:wakili/common/res/colors.dart';
import 'package:wakili/features/account/presentation/widgets/change_password.dart';
import 'package:wakili/features/account/presentation/widgets/section_header_widget.dart';
import 'package:wakili/features/account/presentation/widgets/profile_list_item_widget.dart';

class ProfileSectionWidget extends StatelessWidget {
  final dynamic user;

  const ProfileSectionWidget({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeaderWidget(title: 'Profile Details'),
          const SizedBox(height: 5),
          _buildProfileCard(context, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, bool isDarkMode) {
    return Card(
      elevation: 0,
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDarkMode
              ? Colors.grey[800]!.withValues(alpha: 0.5)
              : Colors.grey[200]!,
        ),
      ),
      child: Column(
        children: [
          ProfileListItemWidget(
            icon: Icons.person_outline,
            title: 'Name',
            value: user.displayName ?? 'Not set',
            onTap: () => _navigateToEditProfile(context),
          ),
          _buildDivider(isDarkMode),
          ProfileListItemWidget(
            icon: Icons.email_outlined,
            title: 'Email',
            value: user.email ?? 'Not set',
            onTap: () => _showEmailNotAvailable(context),
          ),
          _buildDivider(isDarkMode),
          ProfileListItemWidget(
            icon: Icons.lock_outline,
            title: 'Password',
            value: '••••••••••',
            onTap: () => _showChangePasswordDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDarkMode) {
    return Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
    );
  }

  Future<void> _navigateToEditProfile(BuildContext context) async {
    final result = await context.router.push(EditProfileRoute(
      currentFirstName: user.firstName ?? '',
      currentLastName: user.lastName ?? '',
      currentPhotoUrl: user.photoUrl,
    ));
    if (result == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: AppColors.brandSecondary,
        ),
      );
    }
  }

  void _showEmailNotAvailable(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Email editing not available yet'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ChangePassword(),
    );
  }
}
