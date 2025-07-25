// features/chat_history/presentation/screens/chat_history_screen.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';
import 'package:wakili/features/chat_history/data/models/chat_conversation.dart';
import 'package:wakili/features/chat_history/presentation/bloc/chat_history_bloc.dart';
import 'package:wakili/features/chat_history/presentation/widgets/chat_history_app_bar.dart';
import 'package:wakili/features/chat_history/presentation/widgets/chat_history_search_bar.dart';
import 'package:wakili/features/chat_history/presentation/widgets/chat_conversation_card.dart';
import 'package:wakili/features/chat_history/presentation/widgets/chat_history_empty_state.dart';
import 'package:wakili/features/chat_history/presentation/widgets/shimmer_chat_conversation_card.dart';

@RoutePage()
class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _searchAnimationController;
  late Animation<double> _searchAnimation;
  String _searchQuery = '';
  bool _isSearchVisible = false;
  String? _currentUserId;
  static const int _minConversationsForSearch = 5;

  @override
  void initState() {
    super.initState();
    _loadUserIdAndChatHistory();
    _searchController.addListener(_onSearchChanged);

    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _searchAnimation = CurvedAnimation(
      parent: _searchAnimationController,
      curve: Curves.easeInOut,
    );
  }

  void _loadUserIdAndChatHistory() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _currentUserId = user.uid;
      });
      context.read<ChatHistoryBloc>().add(LoadChatHistory(userId: user.uid));
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please log in to view your chat history.'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  // Method to trigger chat history reload
  void _refetchChatHistory() {
    if (_currentUserId != null) {
      context
          .read<ChatHistoryBloc>()
          .add(LoadChatHistory(userId: _currentUserId!));
    } else {
      _loadUserIdAndChatHistory();
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchAnimationController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  List<ChatConversation> _filterConversations(
      List<ChatConversation> conversations) {
    if (_searchQuery.isEmpty) return conversations;
    return conversations
        .where((conversation) => conversation.matchesSearch(_searchQuery))
        .toList();
  }

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (_isSearchVisible) {
        _searchAnimationController.forward();
      } else {
        _searchAnimationController.reverse();
        _searchController.clear();
      }
    });
  }

  void _navigateToChat(ChatConversation conversation) {
    final heroTag = 'conversation-${conversation.id}';
    AutoRouter.of(context).push(
      ChatRoute(
        initialMessages: conversation.messages,
        conversationId: conversation.id,
        category: conversation.category,
        initialTitle: conversation.title,
        heroTag: heroTag,
      ),
    );
  }

  void _showDeleteConfirmationDialog(ChatConversation conversation) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Conversation'),
        content: Text(
          'Are you sure you want to delete "${conversation.title}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (_currentUserId != null) {
                context.read<ChatHistoryBloc>().add(
                      DeleteConversation(
                        conversationId: conversation.id,
                        userId: _currentUserId!,
                      ),
                    );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                        'Error: User not authenticated for deletion.'),
                    backgroundColor: colorScheme.error,
                  ),
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: ChatHistoryAppBar(
        isSearchVisible: _isSearchVisible,
        onToggleSearch: _toggleSearch,
        colorScheme: colorScheme,
      ),
      body: Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SizeTransition(
                sizeFactor: animation,
                axisAlignment: -1.0,
                child: child,
              );
            },
            child: _isSearchVisible
                ? ChatHistorySearchBar(
                    key: const ValueKey('search_bar'),
                    searchAnimation: _searchAnimation,
                    searchController: _searchController,
                    searchQuery: _searchQuery,
                    minConversationsForSearch: _minConversationsForSearch,
                  )
                : const SizedBox.shrink(key: ValueKey('no_search_bar')),
          ),
          Expanded(
            child: BlocConsumer<ChatHistoryBloc, ChatHistoryState>(
              listener: (context, state) {
                if (state is ChatHistoryError && state.message != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message!),
                      backgroundColor: colorScheme.error,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else if (state is ChatHistoryLoaded &&
                    state.message != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message!),
                      backgroundColor: colorScheme.primary,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is ChatHistoryLoading) {
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: 5,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return ShimmerChatConversationCard(
                          colorScheme: colorScheme);
                    },
                  );
                }

                List<ChatConversation> conversations = state.conversations;
                final filteredConversations =
                    _filterConversations(conversations);

                if (filteredConversations.isEmpty) {
                  return ChatHistoryEmptyState(
                    colorScheme: colorScheme,
                    isSearchEmpty: _searchQuery.isNotEmpty,
                    hasConversationsBeforeFilter: conversations.isNotEmpty,
                    onRefetch: _refetchChatHistory,
                  );
                }

                return RefreshIndicator.adaptive(
                  onRefresh: () async {
                    _refetchChatHistory();
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: filteredConversations.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final conversation = filteredConversations[index];
                      final heroTag = 'conversation-${conversation.id}';
                      return ChatConversationCard(
                        conversation: conversation,
                        colorScheme: colorScheme,
                        onTap: () => _navigateToChat(conversation),
                        onDelete: () =>
                            _showDeleteConfirmationDialog(conversation),
                        onFavorite: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Favorite "${conversation.title}" clicked!')),
                          );
                        },
                        heroTag: heroTag,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
