// widgets/autoplay_indicator.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AutoplayIndicator extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onStop;

  const AutoplayIndicator({
    super.key,
    required this.isVisible,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.black, Colors.white],
                  stops: [0.5, 0.5],
                ).createShader(bounds),
                child: const Icon(
                  Icons.play_arrow,
                  size: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.black, Colors.white],
                  stops: [0.5, 0.5],
                ).createShader(bounds),
                child: Text(
                  'Auto-playing',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: onStop,
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Colors.black, Colors.white],
                stops: [0.5, 0.5],
              ).createShader(bounds),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  'Stop',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
