import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:wakili/features/overview/domain/entities/legal_document.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakili/features/wakili/presentation/bloc/wakili_bloc.dart';
import 'package:wakili/features/wakili/presentation/widgets/chat_input_field.dart';
import 'package:wakili/features/wakili/data/models/chat_message.dart';
import 'package:get_it/get_it.dart';

@RoutePage()
class DocumentDetailScreen extends StatefulWidget {
  final LegalDocument document;

  const DocumentDetailScreen({super.key, required this.document});

  @override
  State<DocumentDetailScreen> createState() => _DocumentDetailScreenState();
}

class _DocumentDetailScreenState extends State<DocumentDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late WakiliBloc _wakiliBloc;
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    _wakiliBloc = GetIt.instance<WakiliBloc>();

    // Initialize with document context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasInitialized) {
        _wakiliBloc.add(const ClearChatEvent());
        _hasInitialized = true;
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(WakiliBloc wakiliBloc) {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    // Create contextual message about the document
    final contextualMessage =
        'Regarding the ${widget.document.type.name} titled "${widget.document.title}": $messageText';

    _messageController.clear();
    _wakiliBloc.add(SendMessageEvent(contextualMessage));
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
    final theme = Theme.of(context);

    return Hero(
      tag: 'document-${widget.document.id}',
      child: Material(
        child: Scaffold(
          backgroundColor: theme.colorScheme.surface,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.1),
                  ),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.1),
                  ),
                ),
                child: PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_horiz,
                    size: 18,
                    color: theme.colorScheme.onSurface,
                  ),
                  offset: const Offset(0, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  onSelected: (String value) {
                    if (value == 'info') {
                      _showDocumentInfo(context);
                    } else if (value == 'clear') {
                      _wakiliBloc.add(const ClearChatEvent());
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'info',
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, size: 20),
                          const SizedBox(width: 12),
                          Text('Document Info'),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'clear',
                      child: Row(
                        children: [
                          Icon(Icons.refresh_outlined, size: 20),
                          const SizedBox(width: 12),
                          Text('Clear Chat'),
                        ],
                      ),
                    ),
                  ],
                ),
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
                      backgroundColor: theme.colorScheme.error,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                }
              },
              builder: (context, state) {
                List<ChatMessage> messages = [];
                bool isLoading = false;

                if (state is WakiliChatLoaded) {
                  messages = state.messages;
                  isLoading = state.isLoading;
                } else if (state is WakiliChatErrorState) {
                  messages = state.messages;
                  isLoading = false;
                }

                return Column(
                  children: [
                    // Header Section
                    _buildHeader(theme),
                    // Chat messages area
                    Expanded(
                      child: _buildChatArea(messages, theme),
                    ),
                    // Typing indicator
                    if (isLoading) _buildTypingIndicator(theme),
                    // Bottom chat input
                    _buildBottomChatInput(isLoading, theme),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 100, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Document type badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color:
                  _getTypeColor(widget.document.type).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                    _getTypeColor(widget.document.type).withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              widget.document.type.name.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: _getTypeColor(widget.document.type),
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Document title
          Text(
            widget.document.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          // Document meta info
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.document.status.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                widget.document.datePublished
                    .toLocal()
                    .toIso8601String()
                    .split('T')[0],
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatArea(List<ChatMessage> messages, ThemeData theme) {
    if (messages.isEmpty) {
      return _buildEmptyState(theme);
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return _buildMessageBubble(message, theme);
      },
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Document summary card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.1),
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.description_outlined,
                        size: 18,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Summary',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  widget.document.summary,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.6,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          // Chat placeholder
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _getTypeColor(widget.document.type)
                      .withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 32,
                  color: _getTypeColor(widget.document.type),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Start a conversation with Wakili',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ask questions, get explanations, or request summaries about this document',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withValues(alpha: 0.8),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.smart_toy_outlined,
                size: 16,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: message.isUser
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20).copyWith(
                  topLeft: message.isUser ? null : const Radius.circular(4),
                  topRight: message.isUser ? const Radius.circular(4) : null,
                ),
                border: message.isUser
                    ? null
                    : Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.1),
                      ),
                boxShadow: message.isUser
                    ? null
                    : [
                        BoxShadow(
                          color:
                              theme.colorScheme.shadow.withValues(alpha: 0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Text(
                message.content,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: message.isUser
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface,
                  height: 1.5,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 12),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_outline,
                size: 16,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withValues(alpha: 0.8),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.smart_toy_outlined,
              size: 16,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20).copyWith(
                topLeft: const Radius.circular(4),
              ),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.1),
              ),
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
                      theme.colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Wakili is thinking...',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomChatInput(bool isLoading, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: BlocBuilder<WakiliBloc, WakiliState>(
          builder: (context, state) {
            final isLoading = state is WakiliChatLoaded && state.isLoading;
            return ChatInputField(
              messageController: _messageController,
              onSendMessage: () => _sendMessage(context.read<WakiliBloc>()),
              hintText: 'Ask about this ${widget.document.type.name}...',
              isLoading: isLoading,
            );
          },
        ),
      ),
    );
  }

  void _showDocumentInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (context, scrollController) => Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Text(
                      'Document Details',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Document overview
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Summary',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              widget.document.summary,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    height: 1.5,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Full content
                      Text(
                        'Full Content',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.document.content,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.6,
                            ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(DocumentType type) {
    switch (type) {
      case DocumentType.act:
        return Colors.green;
      case DocumentType.bill:
        return Colors.blue;
      case DocumentType.law:
        return Colors.purple;
      case DocumentType.amendment:
        return Colors.orange;
      case DocumentType.regulation:
        return Colors.teal;
    }
  }
}
