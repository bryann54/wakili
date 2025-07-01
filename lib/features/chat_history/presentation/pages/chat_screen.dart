import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';
import 'package:wakili/features/wakili/data/models/chat_message.dart';
import 'package:wakili/features/wakili/presentation/bloc/wakili_bloc.dart';
// ... other imports

@RoutePage()
class ChatScreen extends StatefulWidget {
  final List<ChatMessage>? initialMessages; // New parameter
  final String? conversationId; // Optional: to identify existing conversation

  const ChatScreen({
    super.key,
    this.initialMessages,
    this.conversationId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // If initial messages are provided, update the bloc's state
    if (widget.initialMessages != null && widget.initialMessages!.isNotEmpty) {
      context.read<WakiliBloc>().add(
            LoadExistingChat(
                widget.initialMessages!), // New event for WakiliBloc
          );
    } else {
      // If no initial messages, ensure the chat is clear or initial
      context.read<WakiliBloc>().add(const ClearChatEvent());
    }
  }

  // ... rest of your ChatScreen code

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wakili AI Chat'),
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
              // This will trigger saving the current chat to history
              context.read<WakiliBloc>().add(const ClearChatEvent());
            },
          ),
        ],
      ),
      body: BlocConsumer<WakiliBloc, WakiliState>(
        listener: (context, state) {
          // You might want to update the conversation title if it changes,
          // or if the chat becomes significant enough to warrant a new title.
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
          }

          return Column(
            children: [
              if (selectedCategory != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Chip(
                    label: Text('Context: $selectedCategory Law'),
                    onDeleted: () {
                      context
                          .read<WakiliBloc>()
                          .add(const ClearCategoryContextEvent());
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
                            vertical: 4.0, horizontal: 8.0),
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: message.isUser
                              ? Colors.blueAccent
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          message.content,
                          style: TextStyle(
                              color:
                                  message.isUser ? Colors.white : Colors.black),
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
                    style: const TextStyle(color: Colors.red),
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
                            context
                                .read<WakiliBloc>()
                                .add(SendMessageEvent(text));
                            _messageController.clear();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    FloatingActionButton(
                      onPressed: () {
                        if (_messageController.text.isNotEmpty) {
                          context
                              .read<WakiliBloc>()
                              .add(SendMessageEvent(_messageController.text));
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
