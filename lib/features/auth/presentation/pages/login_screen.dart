import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';
import 'package:wakili/features/auth/presentation/bloc/auth_bloc.dart';

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
  bool _canLogin = false; // New state variable to control button enablement

  @override
  void initState() {
    super.initState();
    // Add listeners to text controllers to check form validity on change
    _emailController.addListener(_checkFormValidity);
    _passwordController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    // Remove listeners to prevent memory leaks
    _emailController.removeListener(_checkFormValidity);
    _passwordController.removeListener(_checkFormValidity);

    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Checks if the email and password fields are filled and valid.
  void _checkFormValidity() {
    // Manually check basic conditions for button enablement
    final bool emailHasContent = _emailController.text.isNotEmpty;
    final bool passwordHasContent = _passwordController.text.isNotEmpty;

    // A simple email regex check for live feedback on email format
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    final bool isEmailFormatValid = emailRegex.hasMatch(_emailController.text);

    // Update _canLogin if conditions change
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
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

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
                    const SizedBox(height: 40),

                    Align(
                      alignment: Alignment.center,
                      child: Hero(
                        // Added Hero here
                        tag: 'app_logo_text', // Same tag as in RegisterScreen
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                            children: const [
                              TextSpan(
                                text: 'Wakili AI',
                                style: TextStyle(color: Colors.lightGreen),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Welcome Back!',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms, curve: Curves.easeOutQuad)
                        .slideY(
                          begin: 0.2,
                          end: 0,
                          duration: 600.ms,
                          curve: Curves.easeOutQuad,
                        ),

                    const SizedBox(height: 8),

                    Text(
                      'Log in to continue',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    )
                        .animate(delay: 200.ms)
                        .fadeIn(duration: 600.ms)
                        .slideY(begin: 0.2, end: 0, duration: 600.ms),

                    const SizedBox(height: 40),

                    // Email field
                    _buildTextField(
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
                    )
                        .animate(delay: 400.ms)
                        .fadeIn(duration: 600.ms)
                        .slideY(begin: 0.2, end: 0),

                    const SizedBox(height: 16),

                    // Password field
                    _buildTextField(
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
                    )
                        .animate(delay: 500.ms)
                        .fadeIn(duration: 600.ms)
                        .slideY(begin: 0.2, end: 0),

                    // Forgot password link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => _showResetPasswordDialog(context),
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
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                    ).animate(delay: 600.ms).fadeIn(duration: 600.ms),

                    const SizedBox(height: 32),

                    // Login button
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        // The button is disabled if AuthBloc is in a loading state OR
                        // if the _canLogin flag is false (meaning fields aren't valid/filled).
                        final bool isDisabled =
                            state is AuthLoading || !_canLogin;

                        return SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: Hero(
                            // Added Hero here
                            tag: 'login_button', // Unique tag for this button
                            child: ElevatedButton(
                              onPressed: isDisabled
                                  ? null // Disable button if isDisabled is true
                                  : () {
                                      // Only validate and submit if the button is enabled
                                      if (_formKey.currentState!.validate()) {
                                        context.read<AuthBloc>().add(
                                              AuthSignInWithEmailAndPassword(
                                                email: _emailController.text
                                                    .trim(),
                                                password: _passwordController
                                                    .text
                                                    .trim(),
                                              ),
                                            );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                                backgroundColor: isDisabled
                                    ? Colors.grey[400]
                                    : Theme.of(context).primaryColor,
                              ),
                              child: state is AuthLoading
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : Text(
                                      'Log In',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // Divider
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Theme.of(context)
                                  .dividerColor
                                  .withValues(alpha: 0.3),
                              endIndent: 12,
                            ),
                          ),
                          Text(
                            'Or log in with',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                          ).animate(delay: 800.ms).fadeIn(duration: 600.ms),
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: Theme.of(context)
                                  .dividerColor
                                  .withValues(alpha: 0.3),
                              indent: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Google Sign-in Button
                    _buildGoogleSignInButton()
                        .animate(delay: 900.ms)
                        .fadeIn(duration: 600.ms),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // Generic TextField builder (same as in RegisterScreen for consistency)
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool? isPasswordVisible,
    VoidCallback? onVisibilityToggle,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? !(isPasswordVisible ?? false) : false,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(fontSize: 15),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(fontSize: 14),
          prefixIcon: Icon(icon, size: 20),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isPasswordVisible ?? false
                        ? Icons.visibility_off
                        : Icons.visibility,
                    size: 20,
                  ),
                  onPressed: onVisibilityToggle,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          errorStyle: GoogleFonts.poppins(
            fontSize: 12,
          ),
        ),
        validator: validator,
        onChanged: (value) {
          _checkFormValidity();
        },
      ),
    );
  }

  Widget _buildGoogleSignInButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final bool isLoading = state is AuthLoading;
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: isLoading
                ? null
                : () {
                    context.read<AuthBloc>().add(const AuthSignInWithGoogle());
                  },
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
              ),
              backgroundColor: Theme.of(context).colorScheme.surface,
            ),
            icon: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Image.asset(
                    'assets/google.png',
                    height: 20,
                    width: 20,
                  ),
            label: Text(
              'Sign in with Google',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account?",
              style: TextStyle(
                fontSize: 17,
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.color
                    ?.withValues(alpha: 0.7),
              ),
            ),
            Hero(
              // Added Hero here
              tag: 'auth_toggle_button', // Same tag as in RegisterScreen
              child: TextButton(
                onPressed: () {
                  // Assuming you have a route for RegisterScreen
                  context.router.push(const RegisterRoute());
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Create Account',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to show reset password dialog
  void _showResetPasswordDialog(BuildContext context) {
    // Implementation for password reset dialog (as it was already present)
    final TextEditingController resetEmailController = TextEditingController();
    final resetFormKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthPasswordResetSent) {
              Navigator.of(dialogContext).pop(); // Close dialog on success
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Password reset email sent to ${resetEmailController.text}'),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is AuthError) {
              // Show error within the dialog or as a SnackBar
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: AlertDialog(
            title: Text(
              'Reset Password',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            content: Form(
              key: resetFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Enter your email to receive a password reset link.',
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: resetEmailController,
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
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Cancel',
                  style: GoogleFonts.poppins(
                      color: Theme.of(context).colorScheme.onSurface),
                ),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  final bool isLoading = state is AuthLoading;
                  return ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            if (resetFormKey.currentState?.validate() ??
                                false) {
                              context.read<AuthBloc>().add(AuthResetPassword(
                                  email: resetEmailController.text.trim()));
                            }
                          },
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            'Send Reset Link',
                            style: GoogleFonts.poppins(),
                          ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
