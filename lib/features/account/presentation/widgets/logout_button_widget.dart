import 'package:auto_route/auto_route.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakili/common/helpers/app_router.gr.dart'; 
import 'package:wakili/common/res/colors.dart';
import 'package:wakili/features/account/presentation/widgets/logout_dialog.dart';
import 'package:wakili/features/auth/presentation/bloc/auth_bloc.dart';

class LogOutButton extends StatefulWidget {
  const LogOutButton({super.key});

  @override
  State<LogOutButton> createState() => _LogOutButtonState();
}

class _LogOutButtonState extends State<LogOutButton> {
  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CustomLogoutDialog(
          onConfirm: () {
            Navigator.of(context).pop(); 
            context
                .read<AuthBloc>()
                .add(AuthSignOut());
          },
          onCancel: () {
            Navigator.of(context).pop(); 
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.router.replaceAll([const GetStartedRoute()]);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Logout Error: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          elevation: 5,
          shadowColor: isLightMode
              ? Colors.black.withValues(alpha:0.3)
              : Colors.white.withValues(alpha:0.1),
          borderRadius: BorderRadius.circular(10),
          color: Colors.transparent,
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final bool isLoading = state is AuthLoading;

              return InkWell(
                onTap: isLoading ? null : _showLogoutConfirmationDialog,
                borderRadius: BorderRadius.circular(10),
                child: Ink(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: isLightMode
                        ? AppColors.primaryButtonGradient
                        : AppColors.accentButtonGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'logout',
                            style: TextStyle(
                              color: AppColors.textPrimaryDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
