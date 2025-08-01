// features/wakili/presentation/widgets/chat_empty_state.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatEmptyState extends StatelessWidget {
  final String categoryTitle;
  final ColorScheme colorScheme;

  const ChatEmptyState({
    super.key,
    required this.categoryTitle,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon with a subtle animation
            FaIcon(
              FontAwesomeIcons.comments,
              size: 30,
              color: colorScheme.primary.withValues(alpha: 0.6),
            )
                .animate()
                .scale(
                  begin: const Offset(0.7, 0.7),
                  end: const Offset(1.0, 1.0),
                  duration: 800.ms,
                  curve: Curves.elasticOut,
                )
                .fadeIn(duration: 600.ms),

            const SizedBox(height: 24),

            // Title
            Text(
              'Start a conversation about $categoryTitle',
              style: GoogleFonts.montserrat(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(duration: 600.ms, delay: 200.ms)
                .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 200.ms),

            // Description
            Text(
              'Type your question below to get legal guidance from Wakili.',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(duration: 600.ms, delay: 400.ms)
                .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 400.ms),

            const SizedBox(height: 50), // Extra space to push content up
          ],
        ),
      ),
    );
  }
}
