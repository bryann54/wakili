import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../data/models/chat_message.dart';

class ChatMessageWidget extends StatefulWidget {
  final ChatMessage message;
  final Function(String messageId, String newContent)? onMessageEdited;
  final Function(String messageId)? onMessageLongPressed;

  const ChatMessageWidget({
    super.key,
    required this.message,
    this.onMessageEdited,
    this.onMessageLongPressed,
  });

  @override
  State<ChatMessageWidget> createState() => _ChatMessageWidgetState();
}

class _ChatMessageWidgetState extends State<ChatMessageWidget>
    with TickerProviderStateMixin {
  late TextEditingController _editingController;
  bool _isEditing = false;
  bool _isExpanded = false;
  bool _isHovered = false;
  late AnimationController _bounceController;
  late AnimationController _expandController;
  late Animation<double> _bounceAnimation;

  static const int _maxCollapsedLines = 4;
  static const double _messagePadding = 16.0;
  static const double _bubbleRadius = 18.0;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: widget.message.content);

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _expandController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _editingController.dispose();
    _bounceController.dispose();
    _expandController.dispose();
    super.dispose();
  }

  bool get _isLongMessage {
    return widget.message.content.split('\n').length > _maxCollapsedLines ||
        widget.message.content.length > 200;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUser = widget.message.isUser;
    final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 3.0,
        horizontal: _messagePadding,
      ),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ScaleTransition(
              scale: _bounceAnimation,
              child: MouseRegion(
                onEnter: (_) => setState(() => _isHovered = true),
                onExit: (_) => setState(() => _isHovered = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  constraints: BoxConstraints(
                    maxWidth: screenWidth * 0.85,
                    minWidth: 60,
                  ),
                  decoration: _buildMessageDecoration(theme, isUser),
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(_bubbleRadius),
                      onTap: _isLongMessage ? _toggleExpanded : null,
                      onLongPress: () => _handleLongPress(context),
                      onTapDown: (_) => _bounceController.forward(),
                      onTapUp: (_) => _bounceController.reverse(),
                      onTapCancel: () => _bounceController.reverse(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildMessageContent(theme, isUser),
                            const SizedBox(height: 4),
                            _buildMessageFooter(theme, isUser),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (_isLongMessage && !_isEditing)
              _buildExpandButton(theme, isUser),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildMessageDecoration(ThemeData theme, bool isUser) {
    return BoxDecoration(
      gradient: isUser
          ? LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.primary.withValues(alpha: 0.85),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : null,
      color: isUser ? null : theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(_bubbleRadius).copyWith(
        bottomLeft:
            isUser ? Radius.circular(_bubbleRadius) : const Radius.circular(4),
        bottomRight:
            isUser ? const Radius.circular(4) : Radius.circular(_bubbleRadius),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: _isHovered ? 0.15 : 0.08),
          blurRadius: _isHovered ? 12 : 8,
          offset: Offset(0, _isHovered ? 4 : 2),
        ),
      ],
    );
  }

  Widget _buildMessageContent(ThemeData theme, bool isUser) {
    if (_isEditing && isUser) {
      return _buildEditingField(theme);
    }

    final textStyle = TextStyle(
      color: isUser ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
      fontSize: 15,
      height: 1.4,
      fontWeight: FontWeight.w400,
    );

    if (_isLongMessage && !_isExpanded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getTruncatedText(),
            style: textStyle,
            maxLines: _maxCollapsedLines,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            '... tap to expand',
            style: textStyle.copyWith(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: textStyle.color?.withValues(alpha: 0.7),
            ),
          ),
        ],
      );
    }

    return SelectableText(
      widget.message.content,
      style: textStyle,
    );
  }

  Widget _buildEditingField(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _editingController,
        autofocus: true,
        maxLines: null,
        style: TextStyle(
          color: theme.colorScheme.onPrimary,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(8),
          hintText: 'Edit your message...',
          hintStyle: TextStyle(
            color: theme.colorScheme.onPrimary.withValues(alpha: 0.6),
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.check_rounded,
                  color: theme.colorScheme.onPrimary,
                  size: 20,
                ),
                onPressed: _saveEdit,
                tooltip: 'Save',
              ),
              IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: theme.colorScheme.onPrimary,
                  size: 20,
                ),
                onPressed: _cancelEdit,
                tooltip: 'Cancel',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageFooter(ThemeData theme, bool isUser) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          DateFormat('HH:mm').format(widget.message.timestamp),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: (isUser
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface)
                .withValues(alpha: 0.6),
          ),
        ),
        if (isUser) ...[
          const SizedBox(width: 4),
          Icon(
            Icons.done_all_rounded,
            size: 14,
            color: theme.colorScheme.onPrimary.withValues(alpha: 0.7),
          ),
        ],
      ],
    );
  }

  Widget _buildExpandButton(ThemeData theme, bool isUser) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: GestureDetector(
        onTap: _toggleExpanded,
        child: AnimatedRotation(
          turns: _isExpanded ? 0.5 : 0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ),
      ),
    );
  }

  String _getTruncatedText() {
    final lines = widget.message.content.split('\n');
    if (lines.length <= _maxCollapsedLines) {
      return widget.message.content.length > 200
          ? widget.message.content.substring(0, 200)
          : widget.message.content;
    }
    return lines.take(_maxCollapsedLines).join('\n');
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _expandController.forward();
    } else {
      _expandController.reverse();
    }
  }

  void _handleLongPress(BuildContext context) {
    HapticFeedback.mediumImpact();
    _showEnhancedContextMenu(context);
  }

  void _showEnhancedContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              _buildContextMenuItem(
                context,
                Icons.copy_rounded,
                'Copy to clipboard',
                () => _copyMessage(context),
              ),
              if (widget.message.isUser && widget.onMessageEdited != null)
                _buildContextMenuItem(
                  context,
                  Icons.edit_rounded,
                  'Edit message',
                  () => _startEditing(context),
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContextMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _copyMessage(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.message.content));
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 16),
            SizedBox(width: 8),
            Text('Message copied!'),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _startEditing(BuildContext context) {
    Navigator.pop(context);
    setState(() => _isEditing = true);
  }

  void _saveEdit() {
    if (_editingController.text.trim().isNotEmpty) {
      widget.onMessageEdited?.call(
        widget.message.id,
        _editingController.text.trim(),
      );
    }
    setState(() => _isEditing = false);
  }

  void _cancelEdit() {
    _editingController.text = widget.message.content;
    setState(() => _isEditing = false);
  }
}
