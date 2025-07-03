// lib/common/widgets/app_logo_widget.dart
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100, // Adjust size as needed
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // Or BoxShape.circle
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        // Replace with your actual app logo (e.g., Image.asset or Icon)
        child: Icon(
          Icons.balance, // Example icon
          size: 60,
          color: Colors.blue.shade800,
        ),
      ),
    );
  }
}
