part of 'overview_bloc.dart';

abstract class OverviewEvent extends Equatable {
  const OverviewEvent();

  @override
  List<Object?> get props => [];
}

class LoadLegalDocuments extends OverviewEvent {
  final DocumentType? filterType;
  final String? searchQuery;

  const LoadLegalDocuments({this.filterType, this.searchQuery});

  @override
  List<Object?> get props => [filterType, searchQuery];
}

class RefreshDocuments extends OverviewEvent {
  const RefreshDocuments();
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
