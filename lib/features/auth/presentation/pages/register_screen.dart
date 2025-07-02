// register_screen.dart
// ignore_for_file: deprecated_member_use

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';
import 'package:wakili/features/auth/presentation/bloc/auth_bloc.dart';
// Import your app colors and widgets if available
// import 'package:wakili/core/utils/colors.dart';
// import 'package:wakili/features/auth/presentation/widgets/app_logo_widget.dart';
// import 'package:wakili/features/auth/presentation/widgets/google_signin_button.dart';

@RoutePage()
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final _formKey =
      GlobalKey<FormState>(); // GlobalKey for managing the Form state

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _canRegister = false; // State variable to control button enablement

  @override
  void initState() {
    super.initState();
    // Add listeners to all text controllers to react to text changes
    _emailController.addListener(_checkFormValidity);
    _passwordController.addListener(_checkFormValidity);
    _confirmPasswordController.addListener(_checkFormValidity);
    _firstNameController.addListener(_checkFormValidity);
    _lastNameController.addListener(_checkFormValidity);
  }

  @override
  void dispose() {
    // Remove listeners to prevent memory leaks
    _emailController.removeListener(_checkFormValidity);
    _passwordController.removeListener(_checkFormValidity);
    _confirmPasswordController.removeListener(_checkFormValidity);
    _firstNameController.removeListener(_checkFormValidity);
    _lastNameController.removeListener(_checkFormValidity);

    // Dispose controllers
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  /// Checks the validity of the entire form and updates the `_canRegister` flag.
  /// This method is called whenever any text field changes.
  void _checkFormValidity() {
    // This method only checks if all fields are *non-empty* and if passwords match.
    // The actual TextFormField validators handle format/length validation.
    final bool allFieldsFilled = _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _firstNameController.text.isNotEmpty &&
        _lastNameController.text.isNotEmpty;

    final bool passwordsMatch =
        _passwordController.text == _confirmPasswordController.text;

    // A simple check for minimum password length before attempting form validate
    final bool passwordLengthMet = (_passwordController.text.length >= 6);

    // A flag to see if the entire form's current values (without showing errors)
    // pass their individual validator checks.
    // We don't call `_formKey.currentState?.validate()` directly here because
    // it would show validation errors instantly as the user types, which is not
    // always desired for button enablement. Instead, we manually check the conditions.
    final bool isFormLogicallyValid =
        allFieldsFilled && passwordsMatch && passwordLengthMet;

    // Only update state if the value of _canRegister has actually changed
    if (_canRegister != isFormLogicallyValid) {
      setState(() {
        _canRegister = isFormLogicallyValid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Navigate to MainRoute upon successful authentication
            context.router.replace(const MainRoute());
          } else if (state is AuthError) {
            // Show error message using a SnackBar
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red.withOpacity(0.9),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
            if (kDebugMode) {
              print('Authentication error: ${state.message}');
            }
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey, // Assign the GlobalKey to the Form
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Hero(
                      // Added Hero here
                      tag: 'app_logo_text', // Unique tag for this widget
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
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
                  Text(
                    'Create Account',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, curve: Curves.easeOutQuad)
                      .slideY(
                          begin: 0.2,
                          end: 0,
                          duration: 600.ms,
                          curve: Curves.easeOutQuad),

                  const SizedBox(height: 8),

                  Text(
                    'Sign up to get started',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.color
                          ?.withOpacity(0.7),
                    ),
                  )
                      .animate(delay: 200.ms)
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.2, end: 0, duration: 600.ms),

                  // // Logo Section (if you have an app logo)
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 28.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       CircleAvatar(
                  //         radius: 50,
                  //         backgroundColor:
                  //             Theme.of(context).colorScheme.primary,
                  //         child: const CircleAvatar(
                  //           radius: 50,
                  //           backgroundImage: AssetImage('assets/dp.png'),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),

                  // Form Fields Section
                  _buildNameFields()
                      .animate(delay: 300.ms)
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 16),

                  _buildEmailField()
                      .animate(delay: 400.ms)
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 16),

                  _buildPasswordField()
                      .animate(delay: 500.ms)
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 16),

                  _buildConfirmPasswordField()
                      .animate(delay: 600.ms)
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.2, end: 0),

                  const SizedBox(height: 32),

                  // Register Button
                  _buildRegisterButton()
                      .animate(delay: 700.ms)
                      .fadeIn(duration: 600.ms)
                      .slideY(begin: 0.2, end: 0),

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
                            color:
                                Theme.of(context).dividerColor.withOpacity(0.3),
                            endIndent: 12,
                          ),
                        ),
                        Text(
                          'Or sign up with',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color
                                ?.withOpacity(0.7),
                          ),
                        ).animate(delay: 800.ms).fadeIn(duration: 600.ms),
                        Expanded(
                          child: Divider(
                            thickness: 1,
                            color:
                                Theme.of(context).dividerColor.withOpacity(0.3),
                            indent: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Google Sign-up Button
                  _buildGoogleSignUpButton()
                      .animate(delay: 900.ms)
                      .fadeIn(duration: 600.ms),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // Generic TextField builder for consistency and reusability
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
          color: Theme.of(context).dividerColor.withOpacity(0.2),
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
        // Trigger _checkFormValidity on every change to update button state
        onChanged: (value) {
          _checkFormValidity();
        },
      ),
    );
  }

  Widget _buildNameFields() {
    return Padding(
      padding: const EdgeInsets.only(top: 60.0),
      child: Row(
        children: [
          Expanded(
            child: _buildTextField(
              controller: _firstNameController,
              label: 'First Name',
              icon: Icons.person_outline,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'First Name is required' : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildTextField(
              controller: _lastNameController,
              label: 'Last Name',
              icon: Icons.person_outline,
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Last Name is required' : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return _buildTextField(
      controller: _emailController,
      label: 'Email',
      icon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Email is required';
        // Basic email regex for validation
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        return emailRegex.hasMatch(value!)
            ? null
            : 'Enter a valid email address';
      },
    );
  }

  Widget _buildPasswordField() {
    return _buildTextField(
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
        if (value?.isEmpty ?? true) return 'Password is required';
        if ((value?.length ?? 0) < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return _buildTextField(
      controller: _confirmPasswordController,
      label: 'Confirm Password',
      icon: Icons.lock_outline,
      isPassword: true,
      isPasswordVisible: _isConfirmPasswordVisible,
      onVisibilityToggle: () {
        setState(() {
          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
        });
      },
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Confirm Password is required';
        if (value != _passwordController.text) return 'Passwords do not match';
        return null;
      },
    );
  }

  Widget _buildRegisterButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // The button is disabled if AuthBloc is in a loading state OR
        // if the _canRegister flag is false (meaning not all fields are valid/filled).
        final bool isDisabled = state is AuthLoading || !_canRegister;

        return SizedBox(
          width: double.infinity,
          height: 50,
          child: Hero(
            tag: 'register_button', // Existing Hero tag
            child: ElevatedButton(
              onPressed: isDisabled
                  ? null // If disabled, onPressed is null
                  : () {
                      // Only attempt to submit if the form is truly valid based on validators
                      if (_formKey.currentState?.validate() ?? false) {
                        context.read<AuthBloc>().add(
                              AuthSignUpWithEmailAndPassword(
                                firstName: _firstNameController.text.trim(),
                                lastName: _lastNameController.text.trim(),
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              ),
                            );
                      }
                    },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                // Conditionally set the background color
                backgroundColor: isDisabled
                    ? Colors.grey[400] // Light grey when disabled
                    : Theme.of(context)
                        .primaryColor, // Your primary color when enabled
              ),
              child: state is AuthLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Create Account',
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
    );
  }

  Widget _buildGoogleSignUpButton() {
    // You might want to also disable this button if AuthBloc is in AuthLoading state
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final bool isLoading = state is AuthLoading;
        return SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: isLoading
                ? null // Disable button if loading
                : () {
                    context.read<AuthBloc>().add(const AuthSignInWithGoogle());
                  },
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(
                color: Theme.of(context).dividerColor.withOpacity(0.3),
              ),
              backgroundColor: Theme.of(context)
                  .colorScheme
                  .surface, // Use theme surface color
            ),
            icon: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Image.asset(
                    'assets/google.png', // Ensure this asset exists in your pubspec.yaml
                    height: 20,
                    width: 20,
                  ),
            label: Text(
              'Sign up with Google',
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
              'Already have an account?',
              style: TextStyle(
                fontSize: 17,
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.color
                    ?.withOpacity(0.7),
              ),
            ),
            Hero(
              // Added Hero here
              tag: 'auth_toggle_button', // Unique tag, matches LoginScreen
              child: TextButton(
                onPressed: () {
                  context.router.maybePop(); // Go back to login
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Sign In',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ],
        ).animate(delay: 1000.ms).fadeIn(duration: 600.ms),
      ),
    );
  }
}
