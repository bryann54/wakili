import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:wakili/features/wakili/presentation/bloc/wakili_bloc.dart';
import 'package:wakili/features/wakili/presentation/widgets/chat_input_field.dart';
import 'package:wakili/features/wakili/data/models/chat_message.dart';

@RoutePage()
class GeneralChatScreen extends StatefulWidget {
  final String initialMessage;

  const GeneralChatScreen({
    super.key,
    required this.initialMessage,
  });

  @override
  State<GeneralChatScreen> createState() => _GeneralChatScreenState();
}

class _GeneralChatScreenState extends State<GeneralChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late WakiliBloc _wakiliBloc;

  @override
  void initState() {
    super.initState();
    _wakiliBloc = GetIt.instance<WakiliBloc>();

    // Send the initial message automatically
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendInitialMessage();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendInitialMessage() {
    // Send to bloc for processing
    _wakiliBloc.add(SendMessageEvent(widget.initialMessage));
    _scrollToBottom();
  }

  void _sendMessage() {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    _messageController.clear();
    _wakiliBloc.add(SendMessageEvent(messageText));
    _scrollToBottom();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('assets/dp.png'),
            ),
            const SizedBox(width: 12),
            const Text(
              'Wakili',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocProvider.value(
        value: _wakiliBloc,
        child: BlocConsumer<WakiliBloc, WakiliState>(
          listener: (context, state) {
            if (state is WakiliChatErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is WakiliChatInitial) {
              return Stack(
                // Wrap the initial state in a stack for the background
                children: [
                  _buildBackground(),
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
            }

            List<ChatMessage> messages = [];
            bool isLoading = false;

            if (state is WakiliChatLoaded) {
              messages = state.messages;
              isLoading = state.isLoading;
            } else if (state is WakiliChatErrorState) {
              messages = state.messages;
              isLoading = false;
            }

            return Stack(
              children: [
                _buildBackground(),
                Column(
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).padding.top +
                            kToolbarHeight),
                    Expanded(
                      child: _buildMessagesList(messages),
                    ),
                    if (isLoading) _buildTypingIndicator(),
                    _buildChatInput(isLoading),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Extracted method to build the background image and overlay
  Widget _buildBackground() {
    return Positioned.fill(
      child: Stack(
        children: [
          Image.asset(
            'assets/wp.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Overlay for dark/light mode accommodation
          // Adjust opacity based on theme brightness
          Container(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                    .withValues(alpha: 0.6) // Darker overlay for dark mode
                : Colors.black
                    .withValues(alpha: 0.3), // Lighter overlay for light mode
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(List<ChatMessage> messages) {
    if (messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: Theme.of(context)
                  .colorScheme
                  .outline
                  .withValues(alpha: 0.7), // Adjust opacity for background
            ),
            const SizedBox(height: 16),
            Text(
              'Start your conversation with Wakili',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.8), // Adjust opacity
                  ),
            ),
          ],
        ),
      );
    }

    // Auto-scroll to bottom when messages update
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(
          16, 0, 16, 16), // Adjust top padding, it's handled by SizedBox above
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          // Adjusted colors for better contrast against background image
          color: message.isUser
              ? Theme.of(context)
                  .colorScheme
                  .primary
                  .withValues(alpha: 0.9) // Slightly transparent primary
              : Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withValues(alpha: 0.9), // Slightly transparent background
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: message.isUser ? const Radius.circular(4) : null,
            bottomLeft: !message.isUser ? const Radius.circular(4) : null,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(
          message.content,
          style: TextStyle(
            color: message.isUser
                ? Theme.of(context).colorScheme.onPrimary // Should be fine
                : Theme.of(context).colorScheme.onSurface, // Should be fine
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withValues(alpha: 0.9), // Match bubble opacity
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Wakili is typing...',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatInput(bool isLoading) {
    return ChatInputField(
      messageController: _messageController,
      onSendMessage: _sendMessage,
      hintText: 'Ask wakili...',
      isLoading: isLoading,
    );
  }
}
