part of 'overview_bloc.dart';

abstract class OverviewState extends Equatable {
  const OverviewState();

  @override
  List<Object?> get props => [];
}

class OverviewInitial extends OverviewState {}

class OverviewLoading extends OverviewState {}

class OverviewLoaded extends OverviewState {
  final List<LegalDocument> documents;
  final bool hasMore;
  final String? nextPageToken;
  final DocumentQuery currentQuery;
  final bool isLoadingMore;
  final String? errorMessage;

  const OverviewLoaded({
    required this.documents,
    required this.hasMore,
    this.nextPageToken,
    required this.currentQuery,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  OverviewLoaded copyWith({
    List<LegalDocument>? documents,
    bool? hasMore,
    String? nextPageToken,
    DocumentQuery? currentQuery,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return OverviewLoaded(
      documents: documents ?? this.documents,
      hasMore: hasMore ?? this.hasMore,
      nextPageToken: nextPageToken ?? this.nextPageToken,
      currentQuery: currentQuery ?? this.currentQuery,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        documents,
        hasMore,
        nextPageToken,
        currentQuery,
        isLoadingMore,
        errorMessage,
      ];
}

class OverviewError extends OverviewState {
  final String message;

  const OverviewError(this.message);

  @override
  List<Object> get props => [message];
}

class ExplanationRequested extends OverviewState {
  final String documentId;
  final String documentTitle;

  const ExplanationRequested({
    required this.documentId,
    required this.documentTitle,
  });

  @override
  List<Object> get props => [documentId, documentTitle];
}
