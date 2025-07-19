// features/wakili/presentation/screens/chat_screen.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';
import 'package:wakili/features/wakili/data/models/chat_message.dart';
import 'package:wakili/features/wakili/presentation/bloc/wakili_bloc.dart';

@RoutePage()
class ChatScreen extends StatefulWidget {
  final List<ChatMessage>? initialMessages;
  final String? conversationId;
  final String? category;
  final String? initialTitle;
  final String? heroTag; // ⭐ NEW: Property to receive Hero tag

  const ChatScreen({
    super.key,
    this.initialMessages,
    this.conversationId,
    this.category,
    this.initialTitle,
    this.heroTag, // ⭐ NEW
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialMessages != null &&
          widget.initialMessages!.isNotEmpty &&
          widget.conversationId != null) {
        context.read<WakiliBloc>().add(
              LoadExistingChatWithCategory(
                widget.initialMessages!,
                widget.category ?? 'General',
                widget.conversationId,
              ),
            );
      } else {
        context.read<WakiliBloc>().add(const ClearChatEvent());
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

  void _sendMessage() {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    context.read<WakiliBloc>().add(SendStreamMessageEvent(messageText));
    _messageController.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title:
            // ⭐ Hero Widget for AppBar Title
            widget.heroTag != null
                ? Hero(
                    tag: widget.heroTag!,
                    child: Material(
                      // Wrap Hero child with Material to avoid text flickering
                      color: Colors.transparent, // Important for Hero text
                      child: Text(
                        widget.initialTitle ?? 'Wakili AI Chat',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                : Text(widget.initialTitle ?? 'Wakili AI Chat'),
        actions: [
          // ⭐ Minimalistic: Replaced individual action buttons with a PopupMenuButton
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: colorScheme.onSurface, // Match app bar foreground color
            ),
            onSelected: (value) {
              if (value == 'chat_history') {
                AutoRouter.of(context).push(const ChatHistoryRoute());
              } else if (value == 'clear_chat') {
                context.read<WakiliBloc>().add(const ClearChatEvent());
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'chat_history',
                child: Row(
                  children: [
                    Icon(Icons.history, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 10),
                    Text('Chat History',
                        style: TextStyle(color: colorScheme.onSurface)),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'clear_chat',
                child: Row(
                  children: [
                    Icon(Icons.clear, color: colorScheme.error),
                    const SizedBox(width: 10),
                    Text('Clear Chat',
                        style: TextStyle(color: colorScheme.error)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocConsumer<WakiliBloc, WakiliState>(
        listener: (context, state) {
          if (state is WakiliChatErrorState && state.message.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          if (state is WakiliChatLoaded) {
            _scrollToBottom();
          }
        },
        builder: (context, state) {
          List<ChatMessage> messages = [];
          bool isLoading = false;
          String? error;
          String? selectedCategory;

          if (state is WakiliChatLoaded) {
            messages = state.messages;
            isLoading = state.isLoading;
            error = state.error;
            selectedCategory = state.selectedCategory;
          } else if (state is WakiliChatErrorState) {
            messages = state.messages;
            error = state.message;
            selectedCategory = state.selectedCategory;
          } else if (state is WakiliChatInitial) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat_bubble_outline,
                        size: 60,
                        color: colorScheme.primary
                            .withValues(alpha: 0.6)), // Fixed typo
                    const SizedBox(height: 16),
                    Text(
                      'Start your conversation with Wakili',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ask about legal topics, get quick answers, or explore categories.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.8), // Fixed typo
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            children: [
              if (selectedCategory != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Chip(
                    avatar: Icon(Icons.category_outlined,
                        color: colorScheme.onSecondaryContainer),
                    label: Text('Context: $selectedCategory Law'),
                    backgroundColor: colorScheme.secondaryContainer,
                    labelStyle: TextStyle(
                        color: colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.w500),
                    onDeleted: () {
                      context.read<WakiliBloc>().add(
                            const ClearCategoryContextEvent(),
                          );
                    },
                    deleteIconColor: colorScheme.onSecondaryContainer,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  reverse: false,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isUser = message.isUser;
                    final borderRadius = BorderRadius.circular(20);

                    return Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 8.0,
                          bottom: 8.0,
                          left: isUser ? 80.0 : 0.0,
                          right: isUser ? 0.0 : 80.0,
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: isUser
                              ? colorScheme.primary
                              : colorScheme.surfaceContainerHighest,
                          borderRadius: isUser
                              ? borderRadius.subtract(const BorderRadius.only(
                                  // Fixed typo
                                  bottomRight: Radius.circular(5)))
                              : borderRadius.subtract(const BorderRadius.only(
                                  // Fixed typo
                                  bottomLeft: Radius.circular(5))),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black
                                  .withValues(alpha: 0.05), // Fixed typo
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          message.content,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: isUser
                                ? colorScheme.onPrimary
                                : colorScheme.onSurface,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (isLoading)
                LinearProgressIndicator(
                  color: colorScheme.primary,
                  backgroundColor:
                      colorScheme.primary.withValues(alpha: 0.2), // Fixed typo
                ),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Error: $error',
                    style: TextStyle(
                        color: colorScheme.error, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type your legal query...',
                          hintStyle: TextStyle(
                              color: colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.7)), // Fixed typo
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: colorScheme.surfaceContainerHigh,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 14.0),
                        ),
                        onSubmitted: (text) {
                          if (text.isNotEmpty && !isLoading) {
                            _sendMessage();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    FloatingActionButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              if (_messageController.text.isNotEmpty) {
                                _sendMessage();
                              }
                            },
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      elevation: 4,
                      shape: const CircleBorder(),
                      child: isLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: colorScheme.onPrimary,
                              ),
                            )
                          : const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
