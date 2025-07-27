import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';
import 'package:wakili/common/res/colors.dart';
import 'package:wakili/features/account/presentation/widgets/logout_button_widget.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final dynamic user;

  const ProfileHeaderWidget({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.brandPrimary.withValues(alpha: 0.8),
            AppColors.brandPrimary.withValues(alpha: 0.4),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              _buildProfileAvatar(context, isDarkMode),
              const SizedBox(height: 16),
              _buildUserName(),
              _buildUserEmail(),
            ],
          ),
          Positioned(
            top: 16,
            right: 16,
            child: LogOutButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar(BuildContext context, bool isDarkMode) {
    return GestureDetector(
      onTap: () async {
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
      },
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 64,
            backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
            child: Hero(
              tag: 'profile-avatar',
              child: CircleAvatar(
                radius: 60,
                backgroundImage: user.photoUrl != null
                    ? CachedNetworkImageProvider(user.photoUrl!)
                    : null,
                backgroundColor:
                    isDarkMode ? Colors.grey[800] : AppColors.dividerColor,
                child: user.photoUrl == null
                    ? Icon(
                        Icons.person,
                        size: 64,
                        color: isDarkMode
                            ? Colors.grey[400]
                            : AppColors.textSecondary,
                      )
                    : null,
              ),
            ),
          ),
          _buildEditButton(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildEditButton(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.brandPrimary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withValues(alpha: 0.4)
                : Colors.grey.withValues(alpha: 0.3),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(Icons.edit, size: 20, color: Colors.white),
    );
  }

  Widget _buildUserName() {
    return Hero(
      tag: 'profile-name',
      child: Material(
        type: MaterialType.transparency,
        child: Text(
          user.displayName ?? 'User',
          style: GoogleFonts.montserrat(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildUserEmail() {
    return Text(
      user.email ?? 'email@example.com',
      style: GoogleFonts.montserrat(
        fontSize: 16,
        color: Colors.white.withValues(alpha: 0.8),
      ),
    );
  }
}
