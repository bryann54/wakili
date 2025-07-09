import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_route/auto_route.dart';
import 'package:wakili/common/res/colors.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';

class BuyMeCoffeeButton extends StatefulWidget {
  final VoidCallback? onPressed;

  const BuyMeCoffeeButton({super.key, this.onPressed});

  @override
  State<BuyMeCoffeeButton> createState() => _BuyMeCoffeeButtonState();
}

class _BuyMeCoffeeButtonState extends State<BuyMeCoffeeButton>
    with TickerProviderStateMixin {
  late AnimationController _steamController;
  late Animation<double> _steamAnimation;

  @override
  void initState() {
    super.initState();

    _steamController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _steamAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _steamController,
      curve: Curves.easeInOutSine,
    ));
  }

  @override
  void dispose() {
    _steamController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'buy-me-coffee-button',
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [
              AppColors.coffeeBrownDark,
              AppColors.coffeeBrownMedium,
              AppColors.coffeeBrownLight,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.coffeeBrownDark.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: widget.onPressed ??
                () {
                  // Navigate to PaymentScreen with hero animation
                  context.router.push(const PaymentRoute());
                },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Coffee Cup with Steam Animation
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Coffee cup
                        const Text(
                          '☕',
                          style: TextStyle(fontSize: 32),
                        ),
                        // Steam animations
                        _buildSteamPuff(offset: -4, delayFactor: 0),
                        _buildSteamPuff(offset: 0, delayFactor: 0.3),
                        _buildSteamPuff(offset: 4, delayFactor: 0.6),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Buy Me a Coffee',
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Support the developer',
                        style: GoogleFonts.montserrat(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w400,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSteamPuff(
      {required double offset, required double delayFactor}) {
    return AnimatedBuilder(
      animation: _steamAnimation,
      builder: (context, child) {
        final double animationValue =
            (_steamAnimation.value + delayFactor) % 1.0;
        final double translateY = -animationValue * 18;
        final double translateX =
            offset * math.sin(animationValue * 2 * math.pi);
        final double opacity = (1 - animationValue).clamp(0.0, 0.6);
        final double height = 6 + (animationValue * 4);

        return Positioned(
          top: 4,
          left: 16 + offset,
          child: Opacity(
            opacity: opacity,
            child: Transform.translate(
              offset: Offset(translateX, translateY),
              child: Container(
                width: 2,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
