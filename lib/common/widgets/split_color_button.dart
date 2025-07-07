import 'package:flutter/material.dart';
import 'package:wakili/common/res/colors.dart';

class SplitColorButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final bool
      isPrimaryButton;

  const SplitColorButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.textStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    this.borderRadius,
    this.boxShadow,
    this.isPrimaryButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color darkSideBg = AppColors.visualDarkBackgroundHalf;
    final Color lightSideBg = AppColors.visualLightBackgroundHalf;


    final Color textOnDarkBackground =
        AppColors.textOnPrimary; 
    final Color textOnLightBackground = AppColors.textPrimary;
    final Color textOnLightBackgroundSecondary = AppColors.textSecondary;

    Widget buttonContent = ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [
          textOnDarkBackground,
          isPrimaryButton
              ? textOnLightBackground
              : textOnLightBackgroundSecondary,
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        stops: const [0.5, 0.5],
      ).createShader(bounds),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: textStyle.copyWith(
          color: AppColors
              .textOnPrimary, 
        ),
      ),
    );

    if (isPrimaryButton) {
      return GestureDetector(
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(16),
            boxShadow: boxShadow,
            gradient: LinearGradient(
              colors: [darkSideBg, lightSideBg],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.5, 0.5],
            ),
          ),
          child: Center(child: buttonContent),
        ),
      );
    } else {
      return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(12),
          ),
        ),
        child: buttonContent,
      );
    }
  }
}
