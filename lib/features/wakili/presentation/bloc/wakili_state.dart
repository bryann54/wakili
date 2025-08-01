part of 'wakili_bloc.dart';

abstract class WakiliState extends Equatable {
  const WakiliState();

  @override
  List<Object?> get props => [];
}

class WakiliChatInitial extends WakiliState {
  const WakiliChatInitial();
}

class WakiliChatLoaded extends WakiliState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;
  final String? selectedCategory;
  final List<LegalCategory> allCategories;
  final DocumentSnapshot? lastCategoryDocument; // New: for pagination
  final bool hasMoreCategories; // New: for pagination

  const WakiliChatLoaded({
    required this.messages,
    this.isLoading = false,
    this.error,
    this.selectedCategory,
    this.allCategories = const [],
    this.lastCategoryDocument, // Initialize
    this.hasMoreCategories = false, // Initialize
  });

  WakiliChatLoaded copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
    String? selectedCategory,
    List<LegalCategory>? allCategories,
    DocumentSnapshot? lastCategoryDocument, // For copyWith
    bool? hasMoreCategories, // For copyWith
  }) {
    return WakiliChatLoaded(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      allCategories: allCategories ?? this.allCategories,
      lastCategoryDocument: lastCategoryDocument ?? this.lastCategoryDocument,
      hasMoreCategories: hasMoreCategories ?? this.hasMoreCategories,
    );
  }

  @override
  List<Object?> get props => [
        messages,
        isLoading,
        error,
        selectedCategory,
        allCategories,
        lastCategoryDocument,
        hasMoreCategories
      ];
}

class WakiliChatErrorState extends WakiliState {
  final String message;
  final List<ChatMessage> messages;
  final String? selectedCategory;
  final List<LegalCategory> allCategories;
  final DocumentSnapshot? lastCategoryDocument; // For consistency
  final bool hasMoreCategories; // For consistency

  const WakiliChatErrorState({
    required this.message,
    required this.messages,
    this.selectedCategory,
    this.allCategories = const [],
    this.lastCategoryDocument,
    this.hasMoreCategories = false,
  });

  @override
  List<Object?> get props => [
        message,
        messages,
        selectedCategory,
        allCategories,
        lastCategoryDocument,
        hasMoreCategories
      ];
}
