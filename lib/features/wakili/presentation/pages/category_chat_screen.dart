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
import 'package:wakili/common/helpers/app_router.gr.dart';

@RoutePage()
class CategoryChatScreen extends StatefulWidget {
  final LegalCategory category;
  final List<ChatMessage>? initialMessages;
  final String? conversationId;

  const CategoryChatScreen({
    super.key,
    required this.category,
    this.initialMessages,
    this.conversationId,
  });

  @override
  State<CategoryChatScreen> createState() => _CategoryChatScreenState();
}

class _CategoryChatScreenState extends State<CategoryChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ensure WakiliBloc is available via context.read
      final wakiliBloc = context.read<WakiliBloc>();

      if (widget.initialMessages != null &&
          widget.initialMessages!.isNotEmpty) {
        wakiliBloc.add(
          LoadExistingChatWithCategory(
            widget.initialMessages!,
            widget.category.title,
          ),
        );
      } else {
        wakiliBloc.add(
          SetCategoryContextEvent(widget.category.title),
        );
      }
      _scrollToBottom();
    });
  }

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

  @override
  Widget build(BuildContext context) {
    // Directly use widget.category.imagePath
    final String backgroundImagePath = widget.category.imagePath;

    return BlocProvider.value(
      value: GetIt.instance<WakiliBloc>(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          title: Row(
            children: [
              Text(
                '${widget.category.title} Wakili',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'history') {
                  AutoRouter.of(context).push(const ChatHistoryRoute());
                } else if (value == 'clear') {
                  // Ensure you read the bloc for dispatching events
                  context.read<WakiliBloc>().add(const ClearChatEvent());
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem<String>(
                  value: 'history',
                  child: ListTile(
                    leading: Icon(Icons.history),
                    title: Text('Chat History'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'clear',
                  child: ListTile(
                    leading: Icon(Icons.clear),
                    title: Text('Clear Chat'),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                backgroundImagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback for missing images
                  return Container(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Center(
                      child: Icon(Icons.broken_image, color: Colors.grey[400]),
                    ),
                  );
                },
              ),
            ),
            Positioned.fill(
              child: Container(
                // Use a proper overlay color, withOpacity is better than withValues for alpha
                color: Colors.black.withValues(alpha: 0.4),
              ),
            ),
            Column(
              children: [
                Hero(
                  tag: 'category_card_${widget.category.title}',
                  child: Material(
                    color: Colors.transparent,
                    child: CategoryFocusBar(category: widget.category),
                  ),
                ),
                Expanded(
                  child: BlocConsumer<WakiliBloc, WakiliState>(
                    listener: (context, state) {
                      if (state is WakiliChatLoaded ||
                          state is WakiliChatErrorState) {
                        _scrollToBottom();
                        if (state is WakiliChatErrorState) {
                          // Check for error state specifically
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Error: ${state.message}'), // Use state.message for error
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
                          // Show typing indicator only when isLoadingTyping is true AND there are no messages yet
                          // Or show it at the end of existing messages if it's the AI's turn
                          if (isLoadingTyping && messages.isEmpty)
                            const ChatTypingIndicator()
                          else if (isLoadingTyping &&
                              messages.isNotEmpty &&
                              !messages.last
                                  .isUser) // Assuming AI is typing after a user message
                            const ChatTypingIndicator(),
                          // You might want a more sophisticated check for when AI is actually typing a response
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
