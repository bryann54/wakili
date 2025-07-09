import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoffeeOptionCard extends StatelessWidget {
  final int amount;
  final String title;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const CoffeeOptionCard({
    super.key,
    required this.amount,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: isSelected ? Colors.green[50] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.green[700] : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'KSH ${amount.toStringAsFixed(0)}',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.green[700] : Colors.blue[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
