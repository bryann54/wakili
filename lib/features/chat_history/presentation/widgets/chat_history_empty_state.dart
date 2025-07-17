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
      descriptionText = 'Start a conversation to see it here.';
      icon = FontAwesomeIcons.comments;
    } else {
      // This case should ideally be covered by `isSearchEmpty` being true if filteredConversations is empty.
      // But as a fallback/clarification for clarity, it means there are conversations, but none match the filter.
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
                color: colorScheme.primaryContainer.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: FaIcon(
                icon,
                size: 48,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              titleText,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              descriptionText,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
