// features/chat_history/presentation/widgets/chat_history_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakili/features/chat_history/data/models/chat_conversation.dart';
import 'package:wakili/features/chat_history/presentation/bloc/chat_history_bloc.dart';

class ChatHistoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearchVisible;
  final VoidCallback onToggleSearch;
  final ColorScheme colorScheme; // ⭐ NEW: Added colorScheme
  final int minConversationsForSearch;

  const ChatHistoryAppBar({
    super.key,
    required this.isSearchVisible,
    required this.onToggleSearch,
    required this.colorScheme, // ⭐ NEW
    this.minConversationsForSearch = 5,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      elevation: 1, // Subtle elevation for separation
      backgroundColor: colorScheme.surface, // Use theme color
      foregroundColor: colorScheme.onSurface, // Use theme color
      title: Text(
        'Chat History',
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold, // Make title bolder
          color: colorScheme.onSurface,
        ),
      ),
      actions: [
        BlocBuilder<ChatHistoryBloc, ChatHistoryState>(
          builder: (context, state) {
            List<ChatConversation> conversations = state.conversations;
            if (conversations.length >= minConversationsForSearch) {
              return IconButton(
                icon: Icon(
                  isSearchVisible ? Icons.close : Icons.search,
                  color: colorScheme.onSurfaceVariant, // Themed icon color
                ),
                onPressed: onToggleSearch,
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
