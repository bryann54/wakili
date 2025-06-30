import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:wakili/common/helpers/base_usecase.dart';
import 'package:wakili/features/wakili/data/models/chat_message.dart'; // Ensure this import is correct
import 'package:wakili/features/wakili/presentation/bloc/wakili_bloc.dart';

import '../widgets/chat_message_widget.dart'; // Ensure this import is correct

@RoutePage()
class WakiliChatScreen extends StatefulWidget {
  const WakiliChatScreen({super.key});

  @override
  State<WakiliChatScreen> createState() => _WakiliChatScreenState();
}

class _WakiliChatScreenState extends State<WakiliChatScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<String> _quickStartPrompts = const [
    'What are my basic constitutional rights?',
    'How do I file a police report?',
    'Explain the court process in Kenya.',
    'What is the Marriage Act in Kenya?',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward(); // Start animation for the initial screen
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
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
    return Scaffold(
           appBar: AppBar(
        title: Row(
          children: [
      

            const Icon(Icons.gavel_outlined, size: 28), 
            const SizedBox(width: 8),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                children: const [
                  TextSpan(text: 'Wakili '),
                  TextSpan(
                    text: 'AI',
                    style: TextStyle(
                      color: Colors.lightGreen, 
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // Set the background color here to maintain the purple shade
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 1, // Add a subtle shadow
        actions: [
          Builder(builder: (context) {
            return IconButton(
              icon: const Icon(
                  Icons.refresh_outlined), // More intuitive icon for clear
              onPressed: () => context.read<WakiliBloc>().add(ClearChatEvent()),
              tooltip: 'Start a new chat',
            );
          }),
        ],
        flexibleSpace: FlexibleSpaceBar(
          background: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withValues(alpha: 0.6),
              BlendMode.srcATop, 
            ),
            child: Image.asset(
              'assets/wp.png', 
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: Center(
                    child: Text(
                      'AppBar background image not found',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 8),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => GetIt.instance<WakiliBloc>(),
        child: Stack(
          children: [
            Positioned.fill(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
                  BlendMode.srcATop,
                ),
                child: Image.asset(
                  'assets/wp.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: Center(
                        child: Icon(
                          Icons.error_outline,
                          color: Theme.of(context).colorScheme.error,
                          size: 40,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  color: Colors.amber.shade50.withValues(alpha: 0.8),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          size: 18, color: Colors.amber.shade800),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'This provides general legal information, not formal legal advice. Consult a qualified advocate for specific legal matters.',
                          style: TextStyle(
                              fontSize: 11, color: Colors.amber.shade900),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
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
                        } else if (state is WakiliChatErrorState) {
                         NoParams();
                        }
                      }
                    },
                    builder: (context, state) {
                      List<ChatMessage> messages = [];
                      bool isLoadingTyping = false;

                      if (state is WakiliChatInitial) {
                        _animationController.forward(from: 0.0);
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '⚖️',
                                  style: TextStyle(fontSize: 70),
                                ),
                                const SizedBox(height: 24),
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                    children: const [
                                      TextSpan(text: 'Hello! I am '),
                                      TextSpan(
                                        text: 'Wakili AI',
                                        style:
                                            TextStyle(color: Colors.lightGreen),
                                      ),
                                      TextSpan(
                                          text:
                                              ',\nhow may i assist you today!!.'),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'I can help you understand:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(color: Colors.grey.shade600),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                Expanded(
                                  child: Wrap(
                                    spacing: 8.0,
                                    runSpacing: 8.0,
                                    alignment: WrapAlignment.center,
                                    children: _quickStartPrompts.map((prompt) {
                                      return ActionChip(
                                        label: Text(prompt,
                                            style:
                                                const TextStyle(fontSize: 13)),
                                        onPressed: () {
                                          _messageController.text = prompt;
                                          _sendMessage(
                                              context.read<WakiliBloc>());
                                        },
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .surfaceVariant
                                            .withValues(alpha: .6),
                                        labelStyle: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        );
                      } else if (state is WakiliChatLoaded) {
                        messages = state.messages;
                        isLoadingTyping = state.isLoading;
                      } else if (state is WakiliChatErrorState) {
                        messages =
                            state.messages; // Show existing messages + error
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
                                return _buildMessageListItem(message);
                              },
                            ),
                          ),
                          if (isLoadingTyping) // Wakili is typing indicator
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withValues(alpha: 0.7),
                                      child: const Icon(Icons.gavel,
                                          size: 14, color: Colors.white),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Wakili is typing...',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                              fontStyle: FontStyle.italic,
                                              color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                // Message Input
                _buildMessageInput(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageListItem(ChatMessage message) {
    return FadeTransition(
      opacity: _fadeAnimation, // Apply fade animation to individual messages
      child: ChatMessageWidget(message: message),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return BlocBuilder<WakiliBloc, WakiliState>(
      builder: (context, state) {
        final isLoading = state is WakiliChatLoaded && state.isLoading;
        return Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHigh,
            borderRadius:
                BorderRadius.circular(30), // More rounded input container
            boxShadow: [
              BoxShadow(
                color:
                    Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  enabled: !isLoading,
                  decoration: InputDecoration(
                    hintText: 'Ask Wakili about Kenyan law...',
                    hintStyle: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant
                            .withValues(alpha: 0.6)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                  maxLines: 5,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: isLoading
                      ? null
                      : (_) => _sendMessage(context.read<WakiliBloc>()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: isLoading
                        ? Colors.grey.shade300
                        : Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white70),
                            ),
                          )
                        : const Icon(
                            Icons.send_rounded), // More modern send icon
                    color: isLoading
                        ? Colors.grey.shade500
                        : Theme.of(context).colorScheme.onPrimary,
                    onPressed: isLoading
                        ? null
                        : () {
                            if (_messageController.text.trim().isNotEmpty) {
                              _sendMessage(context.read<WakiliBloc>());
                            }
                          },
                    splashRadius: 24,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
