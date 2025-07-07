import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakili/common/res/colors.dart';

class IntroScreenPage extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;

  const IntroScreenPage({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final Color darkSideTextColor = AppColors.textOnPrimary;
    final Color lightSideTextColor = AppColors.textPrimary;
    final Color lightSideSecondaryTextColor = AppColors.textSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: 'intro-image-$imageUrl',
            child: Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.asset(
                  imageUrl,
                  height: 280,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 56),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                darkSideTextColor,
                lightSideTextColor,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.5, 0.5],
            ).createShader(bounds),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: AppColors.textOnPrimary,
                height: 1.2,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                darkSideTextColor.withValues(alpha: 0.85),
                lightSideSecondaryTextColor.withValues(alpha: 0.9),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.5, 0.5],
            ).createShader(bounds),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 17,
                color: AppColors.textOnPrimary,
                height: 1.5,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
