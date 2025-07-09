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
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? Colors.green : Colors.grey[300],
          foregroundColor: Colors.white,
          elevation: isEnabled ? 4 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/M-PESA.png',
              height: 28,
              width: 28,
            ),
            const SizedBox(width: 12),
            Text(
              isEnabled
                  ? 'Pay KSH ${amount.toStringAsFixed(0)}'
                  : 'Select amount and enter phone',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isEnabled ? Colors.white : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
