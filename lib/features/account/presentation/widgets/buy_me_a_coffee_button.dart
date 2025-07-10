import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_route/auto_route.dart';
import 'package:wakili/common/res/colors.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';
import 'package:wakili/features/payment/presentation/widgets/steam_animation_widget.dart';

class BuyMeCoffeeButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const BuyMeCoffeeButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'buy-me-coffee-hero',
      flightShuttleBuilder: (flightContext, animation, flightDirection,
          fromHeroContext, toHeroContext) {
        final Widget toHero = toHeroContext.widget;

        if (flightDirection == HeroFlightDirection.push) {
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Transform.scale(
                scale: Tween<double>(begin: 0.8, end: 1.0)
                    .animate(CurvedAnimation(
                      parent: animation,
                      curve: Curves.fastOutSlowIn,
                    ))
                    .value,
                child: Opacity(
                  opacity: Tween<double>(begin: 0.0, end: 1.0)
                      .animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeIn,
                      ))
                      .value,
                  child: toHero,
                ),
              );
            },
          );
        } else {
          return toHero;
        }
      },
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
            onTap: onPressed ??
                () {
                  context.router.push(
                    const PaymentRoute(),
                    onFailure: (failure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Failed to navigate to payment screen',
                            style: GoogleFonts.montserrat(),
                          ),
                        ),
                      );
                    },
                  );
                },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Coffee Cup with Steam Animation using the reusable widget
                  SteamAnimation(
                    steamColor: Colors.white,
                    steamOpacity: 0.7,
                    steamHeight: 18.0,
                    steamWidth: 2.0,
                    steamCount: 3,
                    steamOffsetRange: 4.0,
                    duration: const Duration(seconds: 2),
                    child: const Text(
                      '☕',
                      style: TextStyle(fontSize: 32),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Buy Wakili Coffee',
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
}
