// features/chat_history/presentation/widgets/chat_history_empty_state.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatHistoryEmptyState extends StatelessWidget {
  final ColorScheme colorScheme;
  final bool isSearchEmpty;
  final bool hasConversationsBeforeFilter;

  const ChatHistoryEmptyState({
    super.key,
    required this.colorScheme,
    required this.isSearchEmpty,
    required this.hasConversationsBeforeFilter,
  });

  @override
  Widget build(BuildContext context) {
    String titleText;
    String descriptionText;
    IconData icon;

    if (isSearchEmpty) {
      titleText = 'No conversations found';
      descriptionText = 'Try adjusting your search terms.';
      icon = FontAwesomeIcons.magnifyingGlassMinus;
    } else if (!hasConversationsBeforeFilter) {
      titleText = 'No chat history yet';
      descriptionText = 'Start a conversation with Wakili to see it here.';
      icon = FontAwesomeIcons.comments;
    } else {
      titleText = 'No matching conversations';
      descriptionText = 'No conversations match your current filter.';
      icon = FontAwesomeIcons.magnifyingGlassMinus;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
                boxShadow: [
                  // Add a subtle shadow
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: FaIcon(
                icon,
                size: 48,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 28), // Increased spacing
            Text(
              titleText,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 22, // Slightly larger font
                fontWeight: FontWeight.bold, // Bolder
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12), // Increased spacing
            Text(
              descriptionText,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.8), // Slightly less opaque
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            // ⭐ Optional: Add an illustration or Lottie animation here for more visual interest
            // if you have a design asset for it.
            // Example: Image.asset('assets/empty_chat.png', height: 150),
          ],
        ),
      ),
    );
  }
}
