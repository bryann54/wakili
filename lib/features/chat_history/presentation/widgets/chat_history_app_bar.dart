import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakili/features/chat_history/data/models/chat_conversation.dart';
import 'package:wakili/features/chat_history/presentation/bloc/chat_history_bloc.dart';

class ChatHistoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearchVisible;
  final VoidCallback onToggleSearch;
  final int minConversationsForSearch; // Pass this threshold

  const ChatHistoryAppBar({
    super.key,
    required this.isSearchVisible,
    required this.onToggleSearch,
    this.minConversationsForSearch = 5, // Default for consistency
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      elevation: 0,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      title: Text(
        'Chat History',
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        BlocBuilder<ChatHistoryBloc, ChatHistoryState>(
          builder: (context, state) {
            List<ChatConversation> conversations = state.conversations;
            // Only show search icon if there are enough conversations
            if (conversations.length >= minConversationsForSearch) {
              return IconButton(
                icon: Icon(isSearchVisible ? Icons.close : Icons.search),
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
