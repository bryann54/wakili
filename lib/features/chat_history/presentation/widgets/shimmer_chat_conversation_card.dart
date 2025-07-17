// features/chat_history/presentation/widgets/shimmer_chat_conversation_card.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerChatConversationCard extends StatelessWidget {
  final ColorScheme colorScheme;

  const ShimmerChatConversationCard({
    super.key,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shadowColor: colorScheme.shadow.withValues(alpha: 0.2),
      surfaceTintColor: colorScheme.surfaceTint.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outline.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Shimmer.fromColors(
          baseColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
          highlightColor:
              colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Shimmer for title
                  Expanded(
                    child: Container(
                      height: 16,
                      width: double.infinity,
                      color: Colors.white, // Placeholder color for shimmer
                    ),
                  ),
                  const SizedBox(width: 24), // Space for more_vert icon
                  Container(
                    width: 20,
                    height: 20,
                    color: Colors.white, // Placeholder for icon
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Shimmer for last message (two lines)
              Container(
                height: 14,
                width: double.infinity,
                color: Colors.white,
              ),
              const SizedBox(height: 4),
              Container(
                height: 14,
                width: MediaQuery.of(context).size.width * 0.6, // Shorter line
                color: Colors.white,
              ),
              const SizedBox(height: 12),
              // Shimmer for time and message count chips
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 50,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
