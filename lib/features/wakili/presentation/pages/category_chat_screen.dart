// features/wakili/presentation/screens/category_chat_screen.dart
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

class _CategoryChatScreenState extends State<CategoryChatScreen>
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
        _wakiliBloc.add(
          LoadExistingChatWithCategory(
            widget.initialMessages!,
            widget.category.title,
            widget.conversationId,
          ),
        );
      } else {
        _wakiliBloc.add(
          SetCategoryContextEvent(widget.category.title),
        );
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
    final String backgroundImagePath = widget.category.imagePath;

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          _wakiliBloc.add(const SaveCurrentChatEvent());
        }
      },
      child: BlocProvider.value(
        value: _wakiliBloc,
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
                    return Container(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: Center(
                        child: Icon(Icons.error, color: Colors.grey[400]),
                      ),
                    );
                  },
                ),
              ),
              Positioned.fill(
                child: Container(
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: ${state.message}'),
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
                            if (isLoadingTyping && messages.isEmpty)
                              const ChatTypingIndicator()
                            else if (isLoadingTyping &&
                                messages.isNotEmpty &&
                                !messages.last.isUser)
                              const ChatTypingIndicator(),
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
      ),
    );
  }
}
