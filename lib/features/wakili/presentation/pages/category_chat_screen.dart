import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:wakili/features/wakili/data/models/chat_message.dart';
import 'package:wakili/features/wakili/presentation/bloc/wakili_bloc.dart';
import 'package:wakili/features/wakili/presentation/widgets/chat_message_widget.dart';
import 'package:wakili/features/wakili/data/models/legal_category.dart';
import 'package:wakili/features/wakili/presentation/widgets/chat_input_field.dart';
import 'package:wakili/features/wakili/presentation/widgets/chat_typing_indicator.dart';
import 'package:wakili/features/wakili/presentation/widgets/category_focus_bar.dart';

@RoutePage()
class CategoryChatScreen extends StatefulWidget {
  final LegalCategory category;

  const CategoryChatScreen({
    super.key,
    required this.category,
  });

  @override
  State<CategoryChatScreen> createState() => _CategoryChatScreenState();
}

class _CategoryChatScreenState extends State<CategoryChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(WakiliBloc chatBloc) {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      chatBloc.add(SendStreamMessageEvent(message));
      _messageController.clear();
      _scrollToBottom();
    }
  }

  // Helper function to get image path based on category title
  String _getChatBackgroundImagePath(String categoryTitle) {
    switch (categoryTitle) {
      case 'Traffic Law':
        return 'assets/wp.png';
      case 'Criminal Law':
        return 'assets/wp.png';
      case 'Family Law':
        return 'assets/wp.png';
      case 'Employment':
        return 'assets/wp.png';
      case 'Property Law':
        return 'assets/wp.png';
      case 'Business Law':
        return 'assets/wp.png';
      case 'Consumer Rights':
        return 'assets/wp.png';
      case 'Constitutional':
        return 'assets/wp.png';
      default:
        return 'assets/wp.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final String backgroundImagePath =
        _getChatBackgroundImagePath(widget.category.title);

    return BlocProvider(
      create: (context) => GetIt.instance<WakiliBloc>()
        ..add(SetCategoryContextEvent(widget.category.title)),
      child: Scaffold(
        appBar: AppBar(
          title: Hero(
              tag: 'category_card_${widget.category.title}',
            child: Text(widget.category.title)),
          backgroundColor: widget.category.color
              .withValues(alpha: 0.1), 
          elevation: 0,
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                backgroundImagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceVariant,
                    child: Center(
                      child: Icon(Icons.broken_image, color: Colors.grey[400]),
                    ),
                  );
                },
              ),
            ),
            Positioned.fill(
              child: Container(
                color: Colors.black
                    .withValues(alpha: 0.4),
              ),
            ),
            Column(
              children: [
                Material(
                  color: Colors.transparent,
                  child: CategoryFocusBar(category: widget.category),
                ),
                Expanded(
                  child: BlocConsumer<WakiliBloc, WakiliState>(
                    listener: (context, state) {
                      if (state is WakiliChatLoaded ||
                          state is WakiliChatErrorState) {
                        _scrollToBottom();
                        if (state is WakiliChatLoaded && state.error != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error: ${state.error}'),
                              backgroundColor:
                                  Theme.of(context).colorScheme.error,
                            ),
                          );
                        }
                      }
                    },
                    builder: (context, state) {
                      List<ChatMessage> messages = [];
                      bool isLoadingTyping = false;

                      if (state is WakiliChatLoaded) {
                        messages = state.messages;
                        isLoadingTyping = state.isLoading;
                      } else if (state is WakiliChatErrorState) {
                        messages = state.messages;
                        isLoadingTyping = false;
                      }

                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(16),
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                final message = messages[index];
                                return ChatMessageWidget(message: message);
                              },
                            ),
                          ),
                          if (isLoadingTyping) const ChatTypingIndicator(),
                        ],
                      );
                    },
                  ),
                ),
                BlocBuilder<WakiliBloc, WakiliState>(
                  builder: (context, state) {
                    final isLoading =
                        state is WakiliChatLoaded && state.isLoading;
                    return ChatInputField(
                      messageController: _messageController,
                      onSendMessage: () =>
                          _sendMessage(context.read<WakiliBloc>()),
                      hintText: 'Ask about ${widget.category.title}...',
                      isLoading: isLoading,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
