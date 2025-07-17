// features/wakili/presentation/screens/general_chat_screen.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:wakili/features/wakili/presentation/bloc/wakili_bloc.dart';
import 'package:wakili/features/wakili/presentation/widgets/chat_input_field.dart';
import 'package:wakili/features/wakili/data/models/chat_message.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';
import 'package:wakili/features/wakili/presentation/widgets/chat_message_widget.dart'; // Import ChatMessageWidget
import 'package:wakili/features/wakili/presentation/widgets/chat_typing_indicator.dart'; // Import ChatTypingIndicator

@RoutePage()
class GeneralChatScreen extends StatefulWidget {
  final String? initialMessage;
  final List<ChatMessage>? initialMessages;
  final String? conversationId;

  const GeneralChatScreen({
    super.key,
    this.initialMessage,
    this.initialMessages,
    this.conversationId,
  });

  @override
  State<GeneralChatScreen> createState() => _GeneralChatScreenState();
}

class _GeneralChatScreenState extends State<GeneralChatScreen>
    with WidgetsBindingObserver {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late WakiliBloc _wakiliBloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _wakiliBloc = GetIt.instance<WakiliBloc>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialMessages != null &&
          widget.initialMessages!.isNotEmpty) {
        _wakiliBloc.add(LoadExistingChat(
          widget.initialMessages!,
          widget.conversationId,
        ));
      } else if (widget.initialMessage != null &&
          widget.initialMessage!.isNotEmpty) {
        _wakiliBloc.add(SendStreamMessageEvent(widget.initialMessage!));
      } else {
        _wakiliBloc.add(const ClearChatEvent());
      }
      _scrollToBottom();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _wakiliBloc.add(const SaveCurrentChatEvent());
    }
  }

  @override
  void dispose() {
    _wakiliBloc.add(const SaveCurrentChatEvent());

    WidgetsBinding.instance.removeObserver(this);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    _messageController.clear();
    _wakiliBloc.add(SendStreamMessageEvent(messageText));
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
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          _wakiliBloc.add(const SaveCurrentChatEvent());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          title: const Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage('assets/dp.png'),
              ),
              SizedBox(width: 12),
              Text(
                'Wakili',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
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
            IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
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
                  children: [
                    _buildBackground(),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 64,
                            color: Theme.of(context)
                                .colorScheme
                                .outline
                                .withValues(alpha: 0.7),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Start your conversation with Wakili',
                            textAlign: TextAlign.center,
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline
                                          .withValues(alpha: 0.8),
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              List<ChatMessage> messages = [];
              bool isLoadingTyping = false;

              if (state is WakiliChatLoaded) {
                messages = state.messages;
                isLoadingTyping = state.isLoading;
              } else if (state is WakiliChatErrorState) {
                messages = state.messages;
                isLoadingTyping = false;
              }

              return Stack(
                children: [
                  _buildBackground(),
                  Column(
                    children: [
                      Expanded(child: _buildMessagesList(messages)),
                      if (isLoadingTyping &&
                          messages.isNotEmpty &&
                          !messages.last.isUser)
                        _buildTypingIndicator()
                      else if (isLoadingTyping && messages.isEmpty)
                        _buildTypingIndicator(),
                      _buildChatInput(isLoadingTyping),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

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
          Container(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withValues(alpha: 0.6)
                : Colors.black.withValues(alpha: 0.3),
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
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 16),
            Text(
              'Start your conversation with Wakili',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.8),
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return ChatMessageWidget(message: message);
      },
    );
  }

  Widget _buildTypingIndicator() {
    return const ChatTypingIndicator();
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
