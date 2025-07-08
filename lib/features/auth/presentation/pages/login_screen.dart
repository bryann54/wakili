import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';
import 'package:wakili/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:wakili/features/auth/presentation/widgets/auth_bottom_bar.dart';
import 'package:wakili/features/auth/presentation/widgets/auth_button.dart';
import 'package:wakili/features/auth/presentation/widgets/auth_divider.dart';
import 'package:wakili/features/auth/presentation/widgets/auth_header.dart';
import 'package:wakili/features/auth/presentation/widgets/auth_text_field.dart';
import 'package:wakili/features/auth/presentation/widgets/google_auth_button.dart';
import 'package:wakili/features/auth/presentation/widgets/password_reset_dialog.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _canLogin = false;

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_checkFormValidity);
    _passwordController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    _emailController.removeListener(_checkFormValidity);
    _passwordController.removeListener(_checkFormValidity);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _checkFormValidity() {
    final bool emailHasContent = _emailController.text.isNotEmpty;
    final bool passwordHasContent = _passwordController.text.isNotEmpty;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final bool isEmailFormatValid = emailRegex.hasMatch(_emailController.text);

    final bool newCanLogin =
        emailHasContent && passwordHasContent && isEmailFormatValid;
    if (_canLogin != newCanLogin) {
      setState(() {
        _canLogin = newCanLogin;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.router.replace(const MainRoute());
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red.withValues(alpha: 0.9),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const AuthHeader(
                      title: 'Welcome Back!',
                      subtitle: 'Log in to continue',
                    ),
                    const SizedBox(height: 40),
                    AuthTextField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value?.isEmpty ?? true) return 'Email is required';
                        final emailRegex =
                            RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        return emailRegex.hasMatch(value!)
                            ? null
                            : 'Enter a valid email';
                      },
                      onChanged: (value) => _checkFormValidity(),
                    )
                        .animate(delay: 400.ms)
                        .fadeIn(duration: 600.ms)
                        .slideY(begin: 0.2, end: 0),
                    const SizedBox(height: 16),
                    AuthTextField(
                      controller: _passwordController,
                      label: 'Password',
                      icon: Icons.lock_outline,
                      isPassword: true,
                      isPasswordVisible: _isPasswordVisible,
                      onVisibilityToggle: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Password is required';
                        }
                        return null;
                      },
                      onChanged: (value) => _checkFormValidity(),
                    )
                        .animate(delay: 500.ms)
                        .fadeIn(duration: 600.ms)
                        .slideY(begin: 0.2, end: 0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => showPasswordResetDialog(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 8,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ).animate(delay: 600.ms).fadeIn(duration: 600.ms),
                    const SizedBox(height: 32),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return AuthButton(
                          text: 'Log In',
                          isEnabled: _canLogin && state is! AuthLoading,
                          isLoading: state is AuthLoading,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(
                                    AuthSignInWithEmailAndPassword(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text.trim(),
                                    ),
                                  );
                            }
                          },
                          heroTag: 'login_button',
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    const AuthDivider(text: 'Or log in with'),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return GoogleAuthButton(
                          text: 'Sign in with Google',
                          isLoading: state is AuthLoading,
                          onPressed: () {
                            context.read<AuthBloc>().add(
                                  const AuthSignInWithGoogle(),
                                );
                          },
                        );
                      },
                    ).animate(delay: 900.ms).fadeIn(duration: 600.ms),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: AuthBottomBar(
        promptText: "Don't have an account?",
        actionText: 'Create Account',
        onActionPressed: () {
          context.router.push(const RegisterRoute());
        },
        heroTag: 'auth_toggle_button',
      ),
    );
  }
}
