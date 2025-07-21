import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';
import 'package:wakili/common/res/colors.dart';
import 'package:wakili/features/account/presentation/bloc/account_bloc.dart';
import 'package:wakili/features/account/presentation/widgets/buy_me_a_coffee_button.dart';
import 'package:wakili/features/account/presentation/widgets/change_password.dart';
import 'package:wakili/features/account/presentation/widgets/logout_button_widget.dart';
import 'package:wakili/features/account/presentation/widgets/profile_shimmer.dart';
import 'package:wakili/features/auth/presentation/bloc/auth_bloc.dart';

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
            listener: (context, state) {
              if (state is AccountError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              } else if (state is AccountProfileUpdated) {
                context.read<AuthBloc>().add(AuthUpdateUser(state.user));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile updated successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is AuthLoading) {
              return const ProfileScreenShimmer();
            }

            if (authState is AuthAuthenticated) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: _buildProfileHeader(context, authState.user),
                  ),
                  SliverToBoxAdapter(
                    child: _buildProfileSection(context, authState.user),
                  ),
                  SliverToBoxAdapter(
                    child: _buildSupportSection(context),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: Column(
                        children: [
                          BuyMeCoffeeButton(),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            return const ProfileScreenShimmer();
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, user) {
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
              GestureDetector(
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
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 64,
                      backgroundColor:
                          isDarkMode ? Colors.grey[850] : Colors.white,
                      child: Hero(
                        tag: 'profile-avatar',
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: user.photoUrl != null
                              ? CachedNetworkImageProvider(user.photoUrl!)
                              : null,
                          backgroundColor: isDarkMode
                              ? Colors.grey[800]
                              : AppColors.dividerColor,
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
                    Container(
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
                      child:
                          const Icon(Icons.edit, size: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Hero(
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
              ),
              const SizedBox(height: 8),
              Text(
                user.email ?? 'email@example.com',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
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

  Widget _buildProfileSection(BuildContext context, user) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, 'Profile Details'),
          const SizedBox(height: 5),
          Card(
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
                _buildProfileListItem(
                  context,
                  icon: Icons.person_outline,
                  title: 'Name',
                  value: user.displayName ?? 'Not set',
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
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                ),
                _buildDivider(isDarkMode),
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
                _buildDivider(isDarkMode),
                _buildProfileListItem(
                  context,
                  icon: Icons.lock_outline,
                  title: 'Password',
                  value: '••••••••••',
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => const ChangePassword(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: isDarkMode ? Colors.grey[300] : AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildProfileListItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.brandPrimary,
              size: 25,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.acme(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode
                          ? Colors.grey[400]
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDarkMode ? Colors.grey[500] : Colors.grey[400],
              size: 28,
            ),
          ],
        ),
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

  Widget _buildSupportSection(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, 'Support'),
          const SizedBox(height: 5),
          Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Card(
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
                child: InkWell(
                  onTap: () {
                    // Navigate to support
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.support_agent_outlined,
                          color: AppColors.brandPrimary,
                          size: 28,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'Help & Support',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isDarkMode
                                  ? Colors.grey[400]
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color:
                              isDarkMode ? Colors.grey[500] : Colors.grey[400],
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Card(
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
                child: InkWell(
                  onTap: () {
                    // Navigate to support
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: AppColors.brandPrimary,
                          size: 28,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'tips & Tricks',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isDarkMode
                                  ? Colors.grey[400]
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color:
                              isDarkMode ? Colors.grey[500] : Colors.grey[400],
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
