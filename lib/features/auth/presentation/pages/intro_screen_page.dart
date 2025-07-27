import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakili/common/res/colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IntroScreenPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const IntroScreenPage({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
      final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final Color leftColor = Colors.black;
    final Color rightColor = Colors.white;
    final Color darkSideTextColor = Colors.white;
    final Color lightSideTextColor = AppColors.textPrimary;
    final Color lightSideSecondaryTextColor = AppColors.textSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with gradient and container styling
Container(
            height: 240,
            width: 240,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  rightColor.withValues(alpha: isDarkMode ? 0.08 : 0.03),
                  leftColor.withValues(alpha: isDarkMode ? 0.12 : 0.05),
                ],
              ),
              border: Border.all(
                color: isDarkMode
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.05),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode
                      ? Colors.black.withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.08),
                  blurRadius: isDarkMode ? 30 : 20,
                  offset: const Offset(0, 10),
                  spreadRadius: isDarkMode ? 2 : 0,
                ),
              ],
            ),
            child: Center(
              child: ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [rightColor, leftColor],
                  stops: const [0.3, 0.7], // Smoother blend
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds),
                child: FaIcon(
                  icon,
                  size: 64,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 56),

          // Enhanced title with gradient
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
                color: Colors.white,
                height: 1.2,
                letterSpacing: -0.5,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Enhanced description
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
                color: Colors.white,
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
