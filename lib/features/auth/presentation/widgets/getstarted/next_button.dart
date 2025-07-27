// widgets/next_button.dart
import 'package:flutter/material.dart';

class NextButton extends StatelessWidget {
  final Animation<double> animation;
  final VoidCallback onPressed;

  const NextButton({
    super.key,
    required this.animation,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16.0),
                shape: const CircleBorder(),
                elevation: 0,
              ),
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
