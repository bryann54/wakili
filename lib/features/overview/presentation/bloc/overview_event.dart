part of 'overview_bloc.dart';

abstract class OverviewEvent extends Equatable {
  const OverviewEvent();

  @override
  List<Object?> get props => [];
}

class LoadLegalDocuments extends OverviewEvent {
  final DocumentQuery query;

  const LoadLegalDocuments(this.query);

  @override
  List<Object?> get props => [query];
}

class LoadMoreDocuments extends OverviewEvent {
  const LoadMoreDocuments();
}

class RefreshDocuments extends OverviewEvent {
  const RefreshDocuments();
}

class SearchDocuments extends OverviewEvent {
  final String searchQuery;
  final DocumentType? filterType;

  const SearchDocuments(this.searchQuery, {this.filterType});

  @override
  List<Object?> get props => [searchQuery, filterType];
}

class FilterDocuments extends OverviewEvent {
  final DocumentType? filterType;

  const FilterDocuments(this.filterType);

  @override
  List<Object?> get props => [filterType];
}

class RequestDocumentExplanation extends OverviewEvent {
  final String documentId;
  final String documentTitle;

  const RequestDocumentExplanation({
    required this.documentId,
    required this.documentTitle,
  });

  @override
  List<Object> get props => [documentId, documentTitle];
}
