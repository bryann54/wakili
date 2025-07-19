// features/chat_history/presentation/widgets/chat_conversation_card.dart
import 'package:flutter/material.dart';
import 'package:wakili/common/utils/date_utils.dart'; // Assuming this utility is available
import 'package:wakili/features/chat_history/data/models/chat_conversation.dart';

class ChatConversationCard extends StatelessWidget {
  final ChatConversation conversation;
  final ColorScheme colorScheme;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onFavorite;
  final String heroTag; // ⭐ NEW: Property for Hero tag

  const ChatConversationCard({
    super.key,
    required this.conversation,
    required this.colorScheme,
    required this.onTap,
    required this.onDelete,
    required this.onFavorite,
    required this.heroTag, // ⭐ NEW
  });

  @override
  Widget build(BuildContext context) {
    final lastMessage = conversation.messages.isNotEmpty
        ? conversation.messages.last.content
        : 'No messages';

    final isNewConversation =
        DateTime.now().difference(conversation.timestamp).inHours < 24;

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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: colorScheme.primary.withValues(alpha: 0.1),
        highlightColor: colorScheme.primary.withValues(alpha: 0.05),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Hero(
                      tag: heroTag,
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          conversation.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  if (isNewConversation) // "New" label for recent conversations
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Chip(
                        label: Text('New',
                            style: TextStyle(
                                fontSize: 10, color: colorScheme.onSecondary)),
                        backgroundColor: colorScheme.secondary
                            .withValues(alpha: 0.7), // Fixed typo
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'delete':
                          onDelete();
                          break;
                        case 'favorite':
                          onFavorite();
                          break;
                      }
                    },
                    icon: Icon(
                      Icons.more_vert,
                      color: colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'favorite',
                        child: Row(
                          children: [
                            Icon(
                              conversation.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 20,
                              color: conversation.isFavorite
                                  ? Colors.red
                                  : colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 12),
                            Text(conversation.isFavorite
                                ? 'Unfavorite'
                                : 'Favorite'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete,
                                color: colorScheme.error, size: 20),
                            const SizedBox(width: 12),
                            Text('Delete',
                                style: TextStyle(color: colorScheme.error)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                lastMessage,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.5), // Fixed typo
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formatDateObj(conversation.timestamp),
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          colorScheme.primaryContainer.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 12,
                          color: colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${conversation.messageCount}',
                          style: TextStyle(
                            color: colorScheme.onPrimaryContainer,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
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
