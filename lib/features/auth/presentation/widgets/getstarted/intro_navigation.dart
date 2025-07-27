// widgets/intro_navigation.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakili/common/res/colors.dart';
import 'package:wakili/features/auth/presentation/widgets/getstarted/split_theme_button.dart';
import 'package:wakili/features/auth/presentation/widgets/getstarted/next_button.dart';

class IntroNavigation extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Animation<double> buttonAnimation;
  final VoidCallback onSkip;
  final VoidCallback onNext;
  final VoidCallback onGetStarted;

  const IntroNavigation({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.buttonAnimation,
    required this.onSkip,
    required this.onNext,
    required this.onGetStarted,
  });

  bool get isLastPage => currentPage == totalPages - 1;

  @override
  Widget build(BuildContext context) {
    if (isLastPage) {
      return _buildLastPageNavigation(context);
    } else {
      return _buildRegularNavigation(context);
    }
  }

  Widget _buildRegularNavigation(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: onSkip,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 12.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Skip',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDarkMode
                    ? AppColors.textLightDark
                    : AppColors.textLightDark,
                letterSpacing: 0.2,
              ),
            ),
          ),
          NextButton(
            animation: buttonAnimation,
            onPressed: onNext,
          ),
        ],
      ),
    );
  }

  Widget _buildLastPageNavigation(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        children: [
          TextButton(
            onPressed: onSkip,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 12.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Already have an account?',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: isDarkMode
                    ? AppColors.textLightDark
                    : AppColors.textSecondary,
                letterSpacing: 0.2,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SplitThemeButton(
            animation: buttonAnimation,
            onPressed: onGetStarted,
          ),
        ],
      ),
    );
  }
}
