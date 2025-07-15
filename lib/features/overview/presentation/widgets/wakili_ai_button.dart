// lib/common/widgets/wakili_ai_button.dart
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';

class WakiliAiButton extends StatelessWidget {
  final String initialMessage;
  final bool isFilled;

  const WakiliAiButton({
    super.key,
    required this.initialMessage,
    this.isFilled = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        );

    final buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.auto_awesome,
            size: 20, color: isFilled ? colors.onPrimary : colors.primary),
        const SizedBox(width: 8),
        Text(
          'Ask Wakili AI',
          style: textStyle?.copyWith(
            color: isFilled ? colors.onPrimary : colors.primary,
          ),
        ),
      ],
    );

    if (isFilled) {
      return FilledButton(
        onPressed: () {
          context.router.push(
            GeneralChatRoute(initialMessage: initialMessage),
          );
        },
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(
              vertical: 16, horizontal: 24), // Adjust padding as needed
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
        ),
        child: buttonChild,
      );
    } else {
      return OutlinedButton(
        onPressed: () {
          context.router.push(
            GeneralChatRoute(initialMessage: initialMessage),
          );
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: colors.primary.withValues(alpha: 0.5)),
          foregroundColor: colors.primary,
        ),
        child: buttonChild,
      );
    }
  }
}
