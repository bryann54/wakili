import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';
import 'package:wakili/features/chat_history/presentation/bloc/chat_history_bloc.dart';

@RoutePage()
class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  State<ChatHistoryScreen> createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Ensure history is loaded when screen is opened
    context.read<ChatHistoryBloc>().add(const LoadChatHistory());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat History'),
      ),
      body: BlocBuilder<ChatHistoryBloc, ChatHistoryState>(
        builder: (context, state) {
          if (state is ChatHistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatHistoryLoaded) {
            if (state.conversations.isEmpty) {
              return const Center(
                child: Text('No chat history available. Start a new chat!'),
              );
            }
            return ListView.builder(
              itemCount: state.conversations.length,
              itemBuilder: (context, index) {
                final conversation = state.conversations[index];
                return Dismissible(
                  key: Key(conversation.id), // Unique key for Dismissible
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    context
                        .read<ChatHistoryBloc>()
                        .add(DeleteChatConversation(conversation.id));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('${conversation.title} dismissed')),
                    );
                  },
                  child: ListTile(
                    title: Text(conversation.title),
                    subtitle: Text(
                      '${conversation.messages.length} messages - ${conversation.timestamp.toLocal().toString().split(' ')[0]}',
                    ),
                    onTap: () {
                      // Navigate to the chat screen with the selected conversation
                      // You'll need to pass the messages to the ChatScreen
                      // and potentially set the WakiliBloc's state to reflect this conversation.
                      // This part requires careful handling in your ChatScreen and WakiliBloc.
                      AutoRouter.of(context).push(
                        ChatRoute(
                          initialMessages: conversation.messages,
                          // You might want to pass the conversation ID as well
                          // to update the title if it's regenerated or save changes.
                          // conversationId: conversation.id,
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (state is ChatHistoryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  if (state.conversations.isNotEmpty)
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.conversations.length,
                        itemBuilder: (context, index) {
                          final conversation = state.conversations[index];
                          return ListTile(
                            title: Text(conversation.title),
                            subtitle: Text(
                              '${conversation.messages.length} messages - ${conversation.timestamp.toLocal().toString().split(' ')[0]}',
                            ),
                            onTap: () {
                              AutoRouter.of(context).push(
                                ChatRoute(
                                    initialMessages: conversation.messages),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  TextButton(
                    onPressed: () {
                      context
                          .read<ChatHistoryBloc>()
                          .add(const LoadChatHistory());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('Unknown state.'));
        },
      ),
    );
  }
}
