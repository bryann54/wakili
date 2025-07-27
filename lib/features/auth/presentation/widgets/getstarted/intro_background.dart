// widgets/intro_background.dart
import 'package:flutter/material.dart';
import 'package:wakili/common/res/colors.dart';

class IntroBackground extends StatelessWidget {
  const IntroBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.visualDarkBackgroundHalf,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.visualDarkBackgroundHalf,
                      AppColors.visualDarkBackgroundHalf
                          .withValues(alpha: 0.95),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.visualLightBackgroundHalf,
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      AppColors.visualLightBackgroundHalf,
                      AppColors.visualLightBackgroundHalf
                          .withValues(alpha: 0.95),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        // Center divider with glow effect
        Positioned(
          left: size.width / 2 - 0.5,
          top: 0,
          bottom: 0,
          child: Container(
            width: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.grey.withValues(alpha: 0.15),
                  Colors.grey.withValues(alpha: 0.3),
                  Colors.grey.withValues(alpha: 0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
