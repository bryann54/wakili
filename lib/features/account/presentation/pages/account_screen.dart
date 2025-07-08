import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakili/features/account/presentation/widgets/profile_shimmer.dart';
import 'package:wakili/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:wakili/features/account/presentation/bloc/account_bloc.dart';
import 'package:wakili/features/account/presentation/widgets/logout_button_widget.dart';
import 'package:wakili/features/account/presentation/widgets/edit_profile_dialog.dart';
import 'package:wakili/features/account/presentation/widgets/change_password.dart';
import 'package:wakili/common/helpers/app_router.gr.dart'; // Ensure this is imported for navigation
import 'package:google_fonts/google_fonts.dart';

@RoutePage()
class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Account',
          style: GoogleFonts.montaga(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
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
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    _buildProfileHeader(context, authState.user),
                    const SizedBox(height: 40),
                    _buildProfileFields(context, authState.user),
                    const SizedBox(height: 20),
                    _buildSupportSection(context),
                    const SizedBox(height: 150),
                    _buildLogoutSection(context),
                  ],
                ),
              );
            }

            return ProfileScreenShimmer();
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, user) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _showEditProfileDialog(context, user),
          child: Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.orange,
                    width: 3,
                  ),
                ),
                child: CircleAvatar(
                  radius: 57,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: user.photoUrl != null
                      ? NetworkImage(user.photoUrl!)
                      : null,
                  child: user.photoUrl == null
                      ? Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.grey[600],
                        )
                      : null,
                ),
              ),
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user.displayName ?? 'User',
          style: GoogleFonts.montaga(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileFields(BuildContext context, user) {
    return Column(
      children: [
        _buildProfileField(
          context,
          icon: Icons.person_outline,
          label: user.displayName ?? '',
          onTap: () => _showEditProfileDialog(context, user),
        ),
        const SizedBox(height: 10),
        _buildProfileField(
          context,
          icon: Icons.email_outlined,
          label: user.email ?? 'nasirahamed4488@gmail.com',
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Email editing not available yet'),
                backgroundColor: Colors.orange,
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        _buildProfileField(
          context,
          icon: Icons.lock_outline,
          label: '••••••••••',
          onTap: () => _showChangePasswordDialog(context),
        ),
      ],
    );
  }

  Widget _buildProfileField(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: 0.05), // Using opacity for brevity
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey[600],
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.acme(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Icon(
              Icons.edit_outlined,
              color: Colors.grey[600],
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.support_agent_outlined,
            color: Colors.grey[600],
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Support',
              style: GoogleFonts.acme(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey[600],
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutSection(BuildContext context) {
    // Directly use the LogOutButton widget, it handles its own BlocListener
    return const LogOutButton();
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
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
        // Password was successfully changed
      }
    });
  }
}
