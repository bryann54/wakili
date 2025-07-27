// widgets/intro_page_indicator.dart
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wakili/common/res/colors.dart';

class IntroPageIndicator extends StatelessWidget {
  final PageController pageController;
  final int itemCount;
  final bool showAutoplayProgress;
  final Duration autoplayDuration;

  const IntroPageIndicator({
    super.key,
    required this.pageController,
    required this.itemCount,
    required this.showAutoplayProgress,
    required this.autoplayDuration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      children: [
        SmoothPageIndicator(
          controller: pageController,
          count: itemCount,
          effect: ExpandingDotsEffect(
            activeDotColor:
                isDarkMode ? AppColors.textPrimary : AppColors.brandPrimary,
            dotColor: isDarkMode
                ? Colors.white.withValues(alpha: 0.25)
                : Colors.grey.withValues(alpha: 0.3),
            dotHeight: 10,
            dotWidth: 10,
            expansionFactor: 3,
            spacing: 12,
          ),
        ),
        if (showAutoplayProgress) ...[
          const SizedBox(height: 16),
          _AutoplayProgressBar(
            duration: autoplayDuration,
            isDarkMode: isDarkMode,
          ),
        ],
      ],
    );
  }
}

class _AutoplayProgressBar extends StatelessWidget {
  final Duration duration;
  final bool isDarkMode;

  const _AutoplayProgressBar({
    required this.duration,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 3,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
      child: TweenAnimationBuilder<double>(
        duration: duration,
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, _) {
          return LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(
              isDarkMode ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          );
        },
      ),
    );
  }
}
