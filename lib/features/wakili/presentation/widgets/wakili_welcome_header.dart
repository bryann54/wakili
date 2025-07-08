import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WakiliWelcomeHeader extends StatefulWidget {
  const WakiliWelcomeHeader({super.key});

  @override
  State<WakiliWelcomeHeader> createState() => _WakiliWelcomeHeaderState();
}

class _WakiliWelcomeHeaderState extends State<WakiliWelcomeHeader>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _floatingController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Start continuous animations
    _pulseController.repeat(reverse: true);
    _floatingController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          // Animated Avatar with multiple effects
          AnimatedBuilder(
            animation:
                Listenable.merge([_pulseController, _floatingController]),
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(
                    0, math.sin(_floatingController.value * 2 * math.pi) * 3),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withValues(
                            alpha: 0.2 + (_pulseController.value * 0.1)),
                        blurRadius: 12 + (_pulseController.value * 8),
                        offset: const Offset(0, 4),
                        spreadRadius: _pulseController.value * 2,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 42 + (_pulseController.value * 2),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: const AssetImage('assets/dp.png'),
                        backgroundColor: Colors.grey[200],
                      ),
                    ),
                  ),
                ),
              );
            },
          )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(
                duration: 2000.ms,
                color: Colors.white.withValues(alpha: 0.3),
                angle: 45,
              )
              .then(delay: 1000.ms)
              .shake(hz: 2, curve: Curves.easeInOut),

          const SizedBox(width: 20),

          // Enhanced Animated Text Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated greeting text
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
                )
                    .animate()
                    .fadeIn(duration: 800.ms, curve: Curves.easeOut)
                    .slideX(
                        begin: -0.3, duration: 800.ms, curve: Curves.easeOut)
                    .then(delay: 200.ms)
                    .animate(onPlay: (controller) => controller.repeat())
                    .shimmer(
                      duration: 3000.ms,
                      color: Colors.lightGreen.withValues(alpha: 0.3),
                      angle: 0,
                    ),

                const SizedBox(height: 4),

                // Animated subtitle with icon
                Row(
                  children: [
                    Icon(
                      Icons.balance,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    )
                        .animate(onPlay: (controller) => controller.repeat())
                        .rotate(
                          duration: 4000.ms,
                          curve: Curves.easeInOut,
                          begin: -0.05,
                          end: 0.05,
                        )
                        .then()
                        .rotate(
                          duration: 4000.ms,
                          curve: Curves.easeInOut,
                          begin: 0.05,
                          end: -0.05,
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
                      )
                          .animate()
                          .fadeIn(
                              duration: 1000.ms,
                              delay: 400.ms,
                              curve: Curves.easeOut)
                          .slideX(
                              begin: -0.2,
                              duration: 1000.ms,
                              delay: 400.ms,
                              curve: Curves.easeOut)
                          .then(delay: 2000.ms)
                          .animate(onPlay: (controller) => controller.repeat())
                          .tint(
                            duration: 3000.ms,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.1),
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, curve: Curves.easeOut)
        .slideY(begin: -0.1, duration: 800.ms, curve: Curves.easeOut);
  }
}
