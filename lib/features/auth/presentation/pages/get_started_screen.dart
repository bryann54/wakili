import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';
import 'package:wakili/common/res/colors.dart'; // Assuming you have this for colors

@RoutePage()
class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDarkMode
              ? AppColors.accentButtonGradient
              : AppColors.primaryButtonGradient,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              // App Logo (re-using the splash screen's logo if desired)
              Hero(
                tag: 'app_logo', // Ensure this tag matches the splash screen
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/wak.png', // Your app logo
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              Text(
                'Welcome to Wakili',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : AppColors.textPrimaryDark,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Your intelligent legal AI assistant. Get started to explore powerful features!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: isDarkMode ? Colors.white70 : AppColors.textSecondary,
                ),
              ),
              const Spacer(flex: 1),
              ElevatedButton(
                onPressed: () {
                  context.router.replace(const LoginRoute());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode
                      ? AppColors.brandAccent
                      : AppColors.brandPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Get Started',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color:
                        isDarkMode ? AppColors.textPrimaryDark : Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Optional: Add a "Sign Up" button or other navigation
              TextButton(
                onPressed: () {
                  // If you have a separate signup flow that doesn't start from LoginRoute
                  // context.router.replace(const SignUpRoute());
                },
                child: Text(
                  'Already have an account?',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color:
                        isDarkMode ? Colors.white54 : AppColors.textSecondary,
                  ),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
