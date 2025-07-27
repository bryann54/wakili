import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakili/common/res/colors.dart';

class SectionHeaderWidget extends StatelessWidget {
  final String title;

  const SectionHeaderWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
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
}
