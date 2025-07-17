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

  const ChatScreen({
    super.key,
    this.initialMessages,
    this.conversationId,
    this.category,
    this.initialTitle,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialTitle ?? 'Wakili AI Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              AutoRouter.of(context).push(const ChatHistoryRoute());
            },
          ),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              context.read<WakiliBloc>().add(const ClearChatEvent());
            },
          ),
        ],
      ),
      body: BlocConsumer<WakiliBloc, WakiliState>(
        listener: (context, state) {
          // Add any specific listeners here, e.g., for showing snackbars on error
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
          } else if (state is WakiliChatInitial) {}

          return Column(
            children: [
              if (selectedCategory != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Chip(
                    label: Text('Context: $selectedCategory Law'),
                    onDeleted: () {
                      context.read<WakiliBloc>().add(
                            const ClearCategoryContextEvent(),
                          );
                    },
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[messages.length - 1 - index];
                    return Align(
                      alignment: message.isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 8.0,
                        ),
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: message.isUser
                              ? colorScheme.primary
                              : colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          message.content,
                          style: TextStyle(
                            color: message.isUser
                                ? colorScheme.onPrimary
                                : colorScheme.onSurface,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (isLoading) const LinearProgressIndicator(),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Error: $error',
                    style: TextStyle(color: colorScheme.error),
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
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        onSubmitted: (text) {
                          if (text.isNotEmpty) {
                            context.read<WakiliBloc>().add(
                                  SendMessageEvent(text),
                                );
                            _messageController.clear();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    FloatingActionButton(
                      onPressed: () {
                        if (_messageController.text.isNotEmpty) {
                          context.read<WakiliBloc>().add(
                                SendMessageEvent(_messageController.text),
                              );
                          _messageController.clear();
                        }
                      },
                      child: const Icon(Icons.send),
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
