import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';
import 'package:wakili/common/res/colors.dart';
import 'package:wakili/features/account/presentation/bloc/account_bloc.dart';
import 'package:wakili/features/account/presentation/widgets/buy_me_a_coffee_button.dart';
import 'package:wakili/features/account/presentation/widgets/profile_header_widget.dart';
import 'package:wakili/features/account/presentation/widgets/profile_section_widget.dart';
import 'package:wakili/features/account/presentation/widgets/support_section_widget.dart';
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
                    backgroundColor: AppColors.error,
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
                    backgroundColor: AppColors.error,
                  ),
                );
              } else if (state is AccountProfileUpdated) {
                context.read<AuthBloc>().add(AuthUpdateUser(state.user));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile updated successfully'),
                    backgroundColor: AppColors.brandSecondary,
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
                    child: ProfileHeaderWidget(user: authState.user),
                  ),
                  SliverToBoxAdapter(
                    child: ProfileSectionWidget(user: authState.user),
                  ),
                  const SliverToBoxAdapter(
                    child: SupportSectionWidget(),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: Column(
                        children: [
                          BuyMeCoffeeButton(),
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
}
