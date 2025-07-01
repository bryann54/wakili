import 'package:flutter/material.dart';

class WakiliWelcomeHeader extends StatelessWidget {
  const WakiliWelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/dp.png'),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Column(
            children: [
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
                'Your legal AI assistant',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
