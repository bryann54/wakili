import 'package:flutter/material.dart';

class WakiliWelcomeHeader extends StatelessWidget {
  const WakiliWelcomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 42,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: CircleAvatar(
                radius: 38,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 35,
                  backgroundImage: const AssetImage('assets/dp.png'),
                  backgroundColor: Colors.grey[200],
                ),
              ),
            ),
          ),

          const SizedBox(width: 20),

          // Enhanced Text Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.onSurface,
                          height: 1.2,
                          letterSpacing: -0.5,
                        ),
                    children: [
                      TextSpan(
                        text: 'Jambo! ',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const TextSpan(text: 'I am '),
                      TextSpan(
                        text: 'Wakili AI',
                        style: TextStyle(
                          background: Paint()
                            ..color = Colors.lightGreen.withValues(alpha: .1)
                            ..strokeWidth = 8
                            ..style = PaintingStyle.stroke
                            ..strokeJoin = StrokeJoin.round,
                          color: Colors.lightGreen.shade700,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.balance,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Your intelligent legal companion',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
