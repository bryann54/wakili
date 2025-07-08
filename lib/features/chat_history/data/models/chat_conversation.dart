import 'package:hive/hive.dart';
import 'package:wakili/features/wakili/data/models/chat_message.dart';

part 'chat_conversation.g.dart';

@HiveType(typeId: 1)
class ChatConversation extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  final List<ChatMessage> messages;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  DateTime updatedAt;

  @HiveField(6)
  final String? category; // Legal category context

  @HiveField(7)
  final List<String> tags; // For better organization

  @HiveField(8)
  final bool isArchived;

  @HiveField(9)
  final bool isFavorite;

  @HiveField(10)
  final String? summary; // AI-generated summary for quick reference

  @HiveField(11)
  final int messageCount;

  @HiveField(12)
  final List<String> searchKeywords; // For enhanced search

  ChatConversation({
    String? id,
    required this.title,
    required this.messages,
    DateTime? timestamp,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.category,
    List<String>? tags,
    this.isArchived = false,
    this.isFavorite = false,
    this.summary,
    int? messageCount,
    List<String>? searchKeywords,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        timestamp = timestamp ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        tags = tags ?? [],
        messageCount = messageCount ?? messages.length,
        searchKeywords =
            searchKeywords ?? _generateSearchKeywords(messages, title);

  // Generate search keywords from messages and title
  static List<String> _generateSearchKeywords(
      List<ChatMessage> messages, String title) {
    final keywords = <String>{};

    // Add title words
    keywords.addAll(title.toLowerCase().split(' '));

    // Add message content words (first few messages for relevance)
    for (int i = 0; i < messages.length && i < 5; i++) {
      final words = messages[i].content.toLowerCase().split(' ');
      keywords
          .addAll(words.where((word) => word.length > 2)); // Filter short words
    }

    // Remove common stop words
    final stopWords = {
      'the',
      'and',
      'or',
      'but',
      'in',
      'on',
      'at',
      'to',
      'for',
      'of',
      'with',
      'by',
      'from',
      'is',
      'are',
      'was',
      'were',
      'be',
      'been',
      'being',
      'have',
      'has',
      'had',
      'do',
      'does',
      'did',
      'will',
      'would',
      'could',
      'should',
      'may',
      'might',
      'can',
      'what',
      'where',
      'when',
      'why',
      'how'
    };
    keywords.removeWhere((word) => stopWords.contains(word));

    return keywords.toList();
  }

  ChatConversation copyWith({
    String? id,
    String? title,
    List<ChatMessage>? messages,
    DateTime? timestamp,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? category,
    List<String>? tags,
    bool? isArchived,
    bool? isFavorite,
    String? summary,
    int? messageCount,
    List<String>? searchKeywords,
  }) {
    return ChatConversation(
      id: id ?? this.id,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      timestamp: timestamp ?? this.timestamp,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      category: category ?? this.category,
      tags: tags ?? this.tags,
      isArchived: isArchived ?? this.isArchived,
      isFavorite: isFavorite ?? this.isFavorite,
      summary: summary ?? this.summary,
      messageCount: messageCount ?? this.messageCount,
      searchKeywords: searchKeywords ?? this.searchKeywords,
    );
  }

  // Helper method to check if conversation matches search query
  bool matchesSearch(String query) {
    final lowerQuery = query.toLowerCase();

    // Check title
    if (title.toLowerCase().contains(lowerQuery)) return true;

    // Check category
    if (category != null && category!.toLowerCase().contains(lowerQuery)) {
      return true;
    }

    // Check tags
    if (tags.any((tag) => tag.toLowerCase().contains(lowerQuery))) return true;

    // Check summary
    if (summary != null && summary!.toLowerCase().contains(lowerQuery)) {
      return true;
    }

    // Check search keywords
    if (searchKeywords.any((keyword) => keyword.contains(lowerQuery))) {
      return true;
    }

    // Check recent messages content
    if (messages.any((msg) => msg.content.toLowerCase().contains(lowerQuery))) {
      return true;
    }

    return false;
  }

  @override
  String toString() {
    return 'ChatConversation(id: $id, title: $title, messageCount: $messageCount, timestamp: $timestamp)';
  }
}
