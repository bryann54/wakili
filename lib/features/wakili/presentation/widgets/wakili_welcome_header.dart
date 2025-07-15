import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class WakiliWelcomeHeader extends StatelessWidget {
  final String? firstName;

  const WakiliWelcomeHeader({super.key, this.firstName});

  @override
  Widget build(BuildContext context) {
    final greetingPrefix =
        firstName?.isNotEmpty == true ? 'Hello, $firstName' : 'Welcome';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildGreetingSection(context, greetingPrefix),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(
          begin: -0.1,
          duration: 700.ms,
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildGreetingSection(BuildContext context, String greetingPrefix) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          RichText(
            text: TextSpan(
              style: GoogleFonts.habibi(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
              children: [
                TextSpan(
                  text: '$greetingPrefix 👋\n',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                TextSpan(
                  text: 'Your ',
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.8),
                  ),
                ),
                TextSpan(
                  text: 'Legal Companion here!',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 600.ms).slideX(
                begin: -0.2,
                duration: 700.ms,
                curve: Curves.easeOutCubic,
              ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.secondaryContainer,
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '⚖️ Legal AI Assistant',
              style: GoogleFonts.acme(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 900.ms, delay: 300.ms)
              .slideX(begin: -0.1, duration: 900.ms, curve: Curves.easeOut),
        ],
      ),
    );
  }
}
