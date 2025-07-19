import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakili/features/chat_history/data/models/chat_conversation.dart';
import 'package:wakili/features/chat_history/presentation/bloc/chat_history_bloc.dart';

class ChatHistorySearchBar extends StatelessWidget {
  final Animation<double> searchAnimation;
  final TextEditingController searchController;
  final String searchQuery;
  final int minConversationsForSearch; // Pass this threshold

  const ChatHistorySearchBar({
    super.key,
    required this.searchAnimation,
    required this.searchController,
    required this.searchQuery,
    this.minConversationsForSearch = 5, // Default for consistency
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<ChatHistoryBloc, ChatHistoryState>(
      builder: (context, state) {
        List<ChatConversation> conversations = state.conversations;

        if (conversations.length >= minConversationsForSearch) {
          return SizeTransition(
            sizeFactor: searchAnimation,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search conversations...',
                  prefixIcon: Icon(
                    Icons.search,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          onPressed: () {
                            searchController.clear();
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.5),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
