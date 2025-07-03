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
  final DocumentType? currentFilter;
  final String? currentSearch;

  const OverviewLoaded({
    required this.documents,
    this.currentFilter,
    this.currentSearch,
  });

  @override
  List<Object?> get props => [documents, currentFilter, currentSearch];
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
