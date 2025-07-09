import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakili/features/account/presentation/widgets/buy_me_a_coffee_button.dart';
import 'package:wakili/features/account/presentation/widgets/profile_shimmer.dart';
import 'package:wakili/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:wakili/features/account/presentation/bloc/account_bloc.dart';
import 'package:wakili/features/account/presentation/widgets/logout_button_widget.dart';
import 'package:wakili/features/account/presentation/widgets/edit_profile_dialog.dart';
import 'package:wakili/features/account/presentation/widgets/change_password.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';
import 'package:wakili/common/res/colors.dart';
import 'package:google_fonts/google_fonts.dart';

@RoutePage()
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
              if (state is AuthUnauthenticated) {
                context.router.replaceAll([const SplashRoute()]);
              }
            },
          ),
          BlocListener<AccountBloc, AccountState>(
            listener: (context, state) {},
          ),
        ],
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is AuthLoading) {
              return const ProfileScreenShimmer();
            }

            if (authState is AuthAuthenticated) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    _buildProfileHeader(context, authState.user),
                    const SizedBox(height: 22),
                    _buildProfileSection(context, authState.user),
                    const SizedBox(height: 24),
                    _buildSupportSection(context),
                    const SizedBox(height: 24),
                    BuyMeCoffeeButton(),
                    const LogOutButton(),
                  ],
                ),
              );
            }

            return const ProfileScreenShimmer();
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, user) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.brandPrimary.withValues(alpha: 0.2),
                  width: 2.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 48,
                backgroundColor: AppColors.dividerColor,
                backgroundImage:
                    user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
                child: user.photoUrl == null
                    ? Icon(
                        Icons.person,
                        size: 50,
                        color: AppColors.textSecondary,
                      )
                    : null,
              ),
            ),
          ],
        ),
        const SizedBox(width: 20),

        // User Name and Email
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.displayName ?? 'User',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 4),
              Text(
                user.email ?? 'email@example.com',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection(BuildContext context, user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Profile',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Colors.grey.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              _buildProfileListItem(
                context,
                icon: Icons.person_outline,
                title: 'Name',
                value: user.displayName ?? 'Not set',
                onTap: () => _showEditProfileDialog(context, user),
              ),
              const Divider(height: 1, indent: 16),
              _buildProfileListItem(
                context,
                icon: Icons.email_outlined,
                title: 'Email',
                value: user.email ?? 'Not set',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Email editing not available yet'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
              ),
              const Divider(height: 1, indent: 16),
              _buildProfileListItem(
                context,
                icon: Icons.lock_outline,
                title: 'Password',
                value: '••••••••••',
                onTap: () => _showChangePasswordDialog(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileListItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.brandPrimary,
        size: 24,
      ),
      title: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey[700],
        ),
      ),
      subtitle: Text(
        value,
        style: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey[400],
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      minVerticalPadding: 0,
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Support',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Colors.grey.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: ListTile(
            leading: Icon(
              Icons.support_agent_outlined,
              color: AppColors.brandPrimary,
              size: 24,
            ),
            title: Text(
              'Help & Support',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
            onTap: () {
              // Navigate to support
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  void _showEditProfileDialog(BuildContext context, user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditProfileDialog(
          currentFirstName: user.displayName?.split(' ').first ?? '',
          currentLastName: user.displayName?.split(' ').length > 1
              ? user.displayName!.split(' ').last
              : '',
        );
      },
    ).then((result) {
      if (result == true) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    });
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ChangePassword();
      },
    ).then((result) {
      if (result == true) {
        if (context.mounted) {
          // Handle success UI updates
        }
      }
    });
  }
}
