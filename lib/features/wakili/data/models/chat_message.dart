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
  final String? messageType;

  @HiveField(5)
  final Map<String, dynamic>? metadata;

  @HiveField(6)
  final String? parentMessageId;

  @HiveField(7)
  final bool isEdited;

  @HiveField(8)
  final DateTime? editedAt;

  @HiveField(9)
  final String? originalContent;

  @HiveField(10)
  final List<String> attachments;

  @HiveField(11)
  final double? confidenceScore;

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

  // ✨ ADDED THIS FACTORY CONSTRUCTOR ✨
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      content: json['content'] as String,
      isUser: json['isUser'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      messageType: json['messageType'] as String?,
      metadata: (json['metadata'] as Map<String, dynamic>?)
          ?.cast<String, dynamic>(), // Ensure correct casting for dynamic map
      parentMessageId: json['parentMessageId'] as String?,
      isEdited: json['isEdited'] as bool? ??
          false, // Handle potential null if not always present
      editedAt: json['editedAt'] != null
          ? DateTime.parse(json['editedAt'] as String)
          : null,
      originalContent: json['originalContent'] as String?,
      attachments: List<String>.from(json['attachments'] as List? ?? []),
      confidenceScore: json['confidenceScore'] as double?,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
    );
  }

  // ✨ ADDED THIS TOJSON METHOD ✨
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'messageType': messageType,
      'metadata': metadata,
      'parentMessageId': parentMessageId,
      'isEdited': isEdited,
      'editedAt': editedAt?.toIso8601String(), // Convert DateTime to String
      'originalContent': originalContent,
      'attachments': attachments,
      'confidenceScore': confidenceScore,
      'isBookmarked': isBookmarked,
    };
  }

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
}
