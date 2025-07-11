import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentButton extends StatelessWidget {
  final bool isEnabled;
  final int amount;
  final VoidCallback onPressed;

  const PaymentButton({
    super.key,
    required this.isEnabled,
    required this.amount,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final buttonColor = isEnabled
        ? isDarkMode
            ? const Color(0xFF4CAF50)
            : const Color(0xFF4CAF50)
        : Colors.grey[isDarkMode ? 700 : 300];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: const Color(0xFF4CAF50)
                      .withOpacity(isDarkMode ? 0.4 : 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isEnabled ? 1.0 : 0.6,
              child: Image.asset(
                'assets/M-PESA.png',
                height: 28,
                width: 28,
                color: isEnabled ? null : Colors.grey[isDarkMode ? 400 : 500],
                colorBlendMode: BlendMode.srcATop,
              ),
            ),
            const SizedBox(width: 16),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  axis: Axis.horizontal,
                  child: child,
                ),
              ),
              child: isEnabled
                  ? Text(
                      'Pay KSH ${amount.toStringAsFixed(0)}',
                      key: const ValueKey('pay-text'),
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Select amount & phone',
                      key: const ValueKey('prompt-text'),
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
