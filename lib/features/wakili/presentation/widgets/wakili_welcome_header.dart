import 'package:flutter/material.dart';

class WakiliWelcomeHeader extends StatelessWidget {
  const WakiliWelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Text(
            '⚖️',
            style: TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 5),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              children: const [
                TextSpan(text: 'Hello! I am '),
                TextSpan(
                  text: 'Wakili AI',
                  style: TextStyle(color: Colors.lightGreen),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your legal assistant for Kenyan law',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
