import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:wakili/features/wakili/presentation/bloc/wakili_bloc.dart';
import 'package:wakili/features/wakili/presentation/widgets/chat_input_field.dart';
import 'package:wakili/features/wakili/data/models/chat_message.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';
import 'package:wakili/features/wakili/presentation/widgets/chat_message_widget.dart';
import 'package:wakili/features/wakili/presentation/widgets/chat_typing_indicator.dart';
import 'package:wakili/features/wakili/presentation/widgets/chat_empty_state.dart'; // Import the new empty state widget
import 'package:google_fonts/google_fonts.dart'; // Import GoogleFonts

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
        // If there's an initial message, send it and then clear the current chat state
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
    final colorScheme = Theme.of(context).colorScheme;

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
          centerTitle: true,
          title: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: colorScheme.primary
                    .withOpacity(0.1), // Added subtle background
                child: const CircleAvatar(
                  radius: 18,
                  backgroundImage: AssetImage('assets/dp.png'),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Wakili',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
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
        body: BlocProvider.value(
          value: _wakiliBloc,
          child: BlocConsumer<WakiliBloc, WakiliState>(
            listener: (context, state) {
              if (state is WakiliChatLoaded || state is WakiliChatErrorState) {
                _scrollToBottom(); // Ensure scroll to bottom on new messages/errors
                if (state is WakiliChatErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${state.message}'),
                      backgroundColor: colorScheme.error,
                    ),
                  );
                }
              }
            },
            builder: (context, state) {
              List<ChatMessage> messages = [];
              bool isLoadingTyping = false;
              bool showEmptyState = false;

              if (state is WakiliChatLoaded) {
                messages = state.messages;
                isLoadingTyping = state.isLoading;
                showEmptyState = messages.isEmpty && !isLoadingTyping;
              } else if (state is WakiliChatErrorState) {
                messages = state.messages;
                isLoadingTyping = false; // Error state usually means no typing
                showEmptyState = messages.isEmpty;
              } else if (state is WakiliChatInitial) {
                showEmptyState = true;
              }

              return Column(
                children: [
                  Expanded(
                    child: showEmptyState
                        ? ChatEmptyState(
                            categoryTitle:
                                'anything', // General chat, so "anything"
                            colorScheme: colorScheme,
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              return ChatMessageWidget(message: message);
                            },
                          ),
                  ),
                  if (isLoadingTyping && messages.isEmpty)
                    const ChatTypingIndicator()
                  else if (isLoadingTyping &&
                      messages.isNotEmpty &&
                      !messages.last.isUser)
                    const ChatTypingIndicator(),
                  ChatInputField(
                    messageController: _messageController,
                    onSendMessage: _sendMessage,
                    hintText: 'Ask Wakili anything...',
                    isLoading: isLoadingTyping,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
