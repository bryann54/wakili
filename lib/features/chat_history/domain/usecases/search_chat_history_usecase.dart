import 'package:injectable/injectable.dart';
import 'package:wakili/features/chat_history/data/models/chat_conversation.dart';
import 'package:wakili/features/chat_history/domain/repositories/chat_history_repository.dart';

enum SearchSortOption {
  relevance,
  dateNewest,
  dateOldest,
  messageCount,
  alphabetical,
}

enum SearchFilter {
  all,
  favorites,
  archived,
  byCategory,
  recent, // Last 7 days
  thisMonth,
  thisYear,
}

@injectable
class SearchChatHistoryUseCase {
  final ChatHistoryRepository _repository;

  SearchChatHistoryUseCase(this._repository);

  Future<List<ChatConversation>> call({
    required String query,
    SearchSortOption sortBy = SearchSortOption.relevance,
    SearchFilter filter = SearchFilter.all,
    String? category,
    int limit = 50,
  }) async {
    final allConversations = await _repository.getChatHistory();

    // Apply search query
    List<ChatConversation> filteredConversations = query.isEmpty
        ? allConversations
        : allConversations
            .where((conversation) => conversation.matchesSearch(query))
            .toList();

    // Apply filters
    filteredConversations =
        _applyFilters(filteredConversations, filter, category);

    // Apply sorting
    filteredConversations = _applySorting(filteredConversations, sortBy, query);

    // Apply limit
    if (limit > 0 && filteredConversations.length > limit) {
      filteredConversations = filteredConversations.take(limit).toList();
    }

    return filteredConversations;
  }

  List<ChatConversation> _applyFilters(
    List<ChatConversation> conversations,
    SearchFilter filter,
    String? category,
  ) {
    switch (filter) {
      case SearchFilter.all:
        return conversations;

      case SearchFilter.favorites:
        return conversations.where((conv) => conv.isFavorite).toList();

      case SearchFilter.archived:
        return conversations.where((conv) => conv.isArchived).toList();

      case SearchFilter.byCategory:
        if (category == null) return conversations;
        return conversations
            .where((conv) => conv.category == category)
            .toList();

      case SearchFilter.recent:
        final weekAgo = DateTime.now().subtract(const Duration(days: 7));
        return conversations
            .where((conv) => conv.timestamp.isAfter(weekAgo))
            .toList();

      case SearchFilter.thisMonth:
        final now = DateTime.now();
        final monthStart = DateTime(now.year, now.month, 1);
        return conversations
            .where((conv) => conv.timestamp.isAfter(monthStart))
            .toList();

      case SearchFilter.thisYear:
        final now = DateTime.now();
        final yearStart = DateTime(now.year, 1, 1);
        return conversations
            .where((conv) => conv.timestamp.isAfter(yearStart))
            .toList();
    }
  }

  List<ChatConversation> _applySorting(
    List<ChatConversation> conversations,
    SearchSortOption sortBy,
    String query,
  ) {
    switch (sortBy) {
      case SearchSortOption.relevance:
        if (query.isEmpty) {
          // If no query, sort by date
          conversations.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        } else {
          // Sort by relevance score
          conversations.sort((a, b) => _calculateRelevanceScore(b, query)
              .compareTo(_calculateRelevanceScore(a, query)));
        }
        break;

      case SearchSortOption.dateNewest:
        conversations.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        break;

      case SearchSortOption.dateOldest:
        conversations.sort((a, b) => a.timestamp.compareTo(b.timestamp));
        break;

      case SearchSortOption.messageCount:
        conversations.sort((a, b) => b.messageCount.compareTo(a.messageCount));
        break;

      case SearchSortOption.alphabetical:
        conversations.sort(
            (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
    }

    return conversations;
  }

  double _calculateRelevanceScore(ChatConversation conversation, String query) {
    final lowerQuery = query.toLowerCase();
    double score = 0.0;

    // Title match (highest weight)
    if (conversation.title.toLowerCase().contains(lowerQuery)) {
      score += 10.0;
      if (conversation.title.toLowerCase().startsWith(lowerQuery)) {
        score += 5.0; // Bonus for starting with query
      }
    }

    // Category match
    if (conversation.category != null &&
        conversation.category!.toLowerCase().contains(lowerQuery)) {
      score += 8.0;
    }

    // Tags match
    for (final tag in conversation.tags) {
      if (tag.toLowerCase().contains(lowerQuery)) {
        score += 6.0;
      }
    }

    // Summary match
    if (conversation.summary != null &&
        conversation.summary!.toLowerCase().contains(lowerQuery)) {
      score += 4.0;
    }

    // Keywords match
    for (final keyword in conversation.searchKeywords) {
      if (keyword.contains(lowerQuery)) {
        score += 2.0;
      }
    }

    // Message content match (sample first few messages)
    final messagesToCheck = conversation.messages.take(5);
    for (final message in messagesToCheck) {
      if (message.content.toLowerCase().contains(lowerQuery)) {
        score += 1.0;
      }
    }

    // Boost recent conversations slightly
    final daysSinceCreation =
        DateTime.now().difference(conversation.timestamp).inDays;
    if (daysSinceCreation < 7) {
      score += 1.0;
    } else if (daysSinceCreation < 30) {
      score += 0.5;
    }

    // Boost favorite conversations
    if (conversation.isFavorite) {
      score += 2.0;
    }

    return score;
  }

  // Get search suggestions based on existing conversations
  Future<List<String>> getSearchSuggestions({String? partialQuery}) async {
    final conversations = await _repository.getChatHistory();
    final suggestions = <String>{};

    // Add popular keywords
    final allKeywords = <String>[];
    for (final conv in conversations) {
      allKeywords.addAll(conv.searchKeywords);
    }

    // Count keyword frequency
    final keywordCount = <String, int>{};
    for (final keyword in allKeywords) {
      keywordCount[keyword] = (keywordCount[keyword] ?? 0) + 1;
    }

    // Get top keywords
    final topKeywords = keywordCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Add suggestions based on partial query
    if (partialQuery != null && partialQuery.isNotEmpty) {
      final lowerQuery = partialQuery.toLowerCase();

      // Add matching keywords
      for (final entry in topKeywords) {
        if (entry.key.contains(lowerQuery)) {
          suggestions.add(entry.key);
        }
      }

      // Add matching titles
      for (final conv in conversations) {
        if (conv.title.toLowerCase().contains(lowerQuery)) {
          suggestions.add(conv.title);
        }
      }

      // Add matching categories
      for (final conv in conversations) {
        if (conv.category != null &&
            conv.category!.toLowerCase().contains(lowerQuery)) {
          suggestions.add(conv.category!);
        }
      }
    } else {
      // Add top keywords as general suggestions
      suggestions.addAll(topKeywords.take(10).map((e) => e.key));
    }

    return suggestions.take(8).toList();
  }

  // Get available categories for filtering
  Future<List<String>> getAvailableCategories() async {
    final conversations = await _repository.getChatHistory();
    final categories = conversations
        .where((conv) => conv.category != null)
        .map((conv) => conv.category!)
        .toSet()
        .toList();

    categories.sort();
    return categories;
  }

  // Get search analytics
  Future<Map<String, dynamic>> getSearchAnalytics() async {
    final conversations = await _repository.getChatHistory();

    final now = DateTime.now();
    final thisMonth = conversations
        .where(
            (conv) => conv.timestamp.isAfter(DateTime(now.year, now.month, 1)))
        .length;
    final thisWeek = conversations
        .where((conv) =>
            conv.timestamp.isAfter(now.subtract(const Duration(days: 7))))
        .length;

    final categories = <String, int>{};
    for (final conv in conversations) {
      if (conv.category != null) {
        categories[conv.category!] = (categories[conv.category!] ?? 0) + 1;
      }
    }

    return {
      'totalConversations': conversations.length,
      'thisMonth': thisMonth,
      'thisWeek': thisWeek,
      'favorites': conversations.where((conv) => conv.isFavorite).length,
      'archived': conversations.where((conv) => conv.isArchived).length,
      'categories': categories,
      'averageMessagesPerConversation': conversations.isEmpty
          ? 0
          : conversations
                  .map((conv) => conv.messageCount)
                  .reduce((a, b) => a + b) /
              conversations.length,
    };
  }
}
