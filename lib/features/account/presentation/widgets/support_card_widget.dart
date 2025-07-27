import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakili/common/res/colors.dart';

class SupportCardWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  const SupportCardWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.colorScheme = const ColorScheme.light(),
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      color: isDarkMode ? Colors.grey[850] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDarkMode
              ? Colors.grey[800]!.withValues(alpha: 0.5)
              : Colors.grey[200]!,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppColors.brandPrimary,
                size: 28,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color:
                        isDarkMode ? Colors.grey[400] : AppColors.textSecondary,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: isDarkMode ? Colors.grey[500] : Colors.grey[400],
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
