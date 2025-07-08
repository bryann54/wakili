import 'package:hive/hive.dart';
import 'package:equatable/equatable.dart';

part 'chat_message.g.dart';

@HiveType(typeId: 0)
class ChatMessage extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final bool isUser;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final String? messageType; // 'text', 'image', 'file', etc.

  @HiveField(5)
  final Map<String, dynamic>? metadata; // For additional data

  @HiveField(6)
  final String? parentMessageId; // For threading/replies

  @HiveField(7)
  final bool isEdited;

  @HiveField(8)
  final DateTime? editedAt;

  @HiveField(9)
  final String? originalContent; // Store original before edit

  @HiveField(10)
  final List<String> attachments; // File paths or URLs

  @HiveField(11)
  final double? confidenceScore; // AI confidence in response

  @HiveField(12)
  final bool isBookmarked;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.messageType = 'text',
    this.metadata,
    this.parentMessageId,
    this.isEdited = false,
    this.editedAt,
    this.originalContent,
    List<String>? attachments,
    this.confidenceScore,
    this.isBookmarked = false,
  }) : attachments = attachments ?? const [];

  ChatMessage copyWith({
    String? id,
    String? content,
    bool? isUser,
    DateTime? timestamp,
    String? messageType,
    Map<String, dynamic>? metadata,
    String? parentMessageId,
    bool? isEdited,
    DateTime? editedAt,
    String? originalContent,
    List<String>? attachments,
    double? confidenceScore,
    bool? isBookmarked,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      messageType: messageType ?? this.messageType,
      metadata: metadata ?? this.metadata,
      parentMessageId: parentMessageId ?? this.parentMessageId,
      isEdited: isEdited ?? this.isEdited,
      editedAt: editedAt ?? this.editedAt,
      originalContent: originalContent ?? this.originalContent,
      attachments: attachments ?? this.attachments,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  // Helper method to get formatted timestamp
  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  // Helper method to get message preview (first 100 chars)
  String get preview {
    if (content.length <= 100) return content;
    return '${content.substring(0, 97)}...';
  }

  @override
  List<Object?> get props => [
        id,
        content,
        isUser,
        timestamp,
        messageType,
        metadata,
        parentMessageId,
        isEdited,
        editedAt,
        originalContent,
        attachments,
        confidenceScore,
        isBookmarked,
      ];

  @override
  String toString() {
    return 'ChatMessage(id: $id, isUser: $isUser, content: ${content.length > 50 ? "${content.substring(0, 50)}..." : content})';
  }
}
