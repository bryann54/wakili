import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakili/features/payment/presentation/widgets/steam_animation_widget.dart';

class CoffeeOptionCard extends StatefulWidget {
  final int amount;
  final String title;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showSteamAnimation;

  const CoffeeOptionCard({
    super.key,
    required this.amount,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.showSteamAnimation = false,
  });

  @override
  State<CoffeeOptionCard> createState() => _CoffeeOptionCardState();
}

class _CoffeeOptionCardState extends State<CoffeeOptionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 110,
              height: 120,
              decoration: BoxDecoration(
                gradient: widget.isSelected
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDarkMode
                            ? [
                                const Color(0xFF2D5A27).withValues(alpha: 0.8),
                                const Color(0xFF4CAF50).withValues(alpha: 0.6),
                              ]
                            : [
                                const Color(0xFF81C784).withValues(alpha: 0.3),
                                const Color(0xFF4CAF50).withValues(alpha: 0.2),
                              ],
                      )
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDarkMode
                            ? [
                                Colors.grey[900]!.withValues(alpha: 0.8),
                                Colors.grey[800]!.withValues(alpha: 0.6),
                              ]
                            : [
                                Colors.white.withValues(alpha: 0.9),
                                Colors.grey[50]!.withValues(alpha: 0.8),
                              ],
                      ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: widget.isSelected
                      ? const Color(0xFF4CAF50)
                      : (isDarkMode ? Colors.grey[700]! : Colors.grey[200]!),
                  width: widget.isSelected ? 2.5 : 1.5,
                ),
                boxShadow: [
                  if (widget.isSelected) ...[
                    BoxShadow(
                      color: const Color(0xFF4CAF50).withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: const Color(0xFF4CAF50).withValues(alpha: 0.2),
                      blurRadius: 40,
                      offset: const Offset(0, 16),
                    ),
                  ] else ...[
                    BoxShadow(
                      color: (isDarkMode ? Colors.black : Colors.grey[400]!)
                          .withValues(alpha: isDarkMode ? 0.4 : 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    // Subtle background pattern
                    if (widget.isSelected)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: Alignment.topRight,
                              radius: 1.5,
                              colors: [
                                Colors.white.withValues(alpha: 0.1),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),

                    // Content
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Icon with enhanced animation
                          Transform.scale(
                            scale: widget.isSelected ? 1.1 : 1.0,
                            child: widget.showSteamAnimation &&
                                    widget.icon == '☕'
                                ? SteamAnimation(
                                    steamColor: isDarkMode
                                        ? Colors.grey[300]!
                                        : Colors.grey[500]!,
                                    steamOpacity: 0.8,
                                    steamHeight: 20.0,
                                    steamWidth: 2.0,
                                    steamCount: 3,
                                    duration: const Duration(seconds: 2),
                                    child: Text(
                                      widget.icon,
                                      style: TextStyle(
                                        fontSize: 28,
                                        shadows: widget.isSelected
                                            ? [
                                                Shadow(
                                                  color: const Color(0xFF4CAF50)
                                                      .withValues(alpha: 0.5),
                                                  blurRadius: 8,
                                                ),
                                              ]
                                            : [],
                                      ),
                                    ),
                                  )
                                : Text(
                                    widget.icon,
                                    style: TextStyle(
                                      fontSize: 28,
                                      shadows: widget.isSelected
                                          ? [
                                              Shadow(
                                                color: const Color(0xFF4CAF50)
                                                    .withValues(alpha: 0.5),
                                                blurRadius: 8,
                                              ),
                                            ]
                                          : [],
                                    ),
                                  ),
                          ),

                          const SizedBox(height: 8),

                          // Title
                          Text(
                            widget.title,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: widget.isSelected
                                  ? (isDarkMode
                                      ? Colors.green[300]
                                      : Colors.green[700])
                                  : (isDarkMode
                                      ? Colors.grey[300]
                                      : Colors.grey[700]),
                              letterSpacing: 0.5,
                            ),
                          ),

                          const SizedBox(height: 4),

                          // Amount with gradient text
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: widget.isSelected
                                  ? [Colors.green[600]!, Colors.green[400]!]
                                  : [
                                      isDarkMode
                                          ? Colors.blue[300]!
                                          : Colors.blue[700]!,
                                      isDarkMode
                                          ? Colors.blue[400]!
                                          : Colors.blue[500]!,
                                    ],
                            ).createShader(bounds),
                            child: Text(
                              'KSH ${widget.amount.toStringAsFixed(0)}',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
