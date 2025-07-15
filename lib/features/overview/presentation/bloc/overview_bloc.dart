// overview_bloc.dart

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/features/overview/domain/entities/legal_document.dart';
import 'package:wakili/features/overview/domain/repositories/legal_document_repository.dart';

part 'overview_event.dart';
part 'overview_state.dart';

@injectable
class OverviewBloc extends Bloc<OverviewEvent, OverviewState> {
  final LegalDocumentRepository _legalDocumentRepository;

  OverviewBloc(this._legalDocumentRepository) : super(OverviewInitial()) {
    on<LoadLegalDocuments>(_onLoadLegalDocuments);
    on<LoadMoreDocuments>(_onLoadMoreDocuments);
    on<RefreshDocuments>(_onRefreshDocuments);
    on<SearchDocuments>(_onSearchDocuments);
    on<FilterDocuments>(_onFilterDocuments);
    on<RequestDocumentExplanation>(_onRequestDocumentExplanation);
  }

  FutureOr<void> _onLoadLegalDocuments(
    LoadLegalDocuments event,
    Emitter<OverviewState> emit,
  ) async {
    // If the current state is OverviewLoaded and we are not explicitly refreshing or starting a new query,
    // we can keep the current query's loading state. Otherwise, emit OverviewLoading.
    if (state is OverviewLoaded &&
        event.query.startAfterDocumentId == null &&
        event.query.searchQuery == null &&
        event.query.filterType == null) {
      // This is to prevent showing a full loading spinner on just a filter change if data is already loaded
    } else {
      emit(OverviewLoading());
    }

    try {
      final result = await _legalDocumentRepository.getLegalDocuments(
        event.query,
      );

      emit(OverviewLoaded(
        documents: result.items,
        hasMore: result.hasMore,
        nextPageToken: result.nextPageToken,
        currentQuery: event.query,
        isLoadingMore: false,
      ));
    } catch (e) {
      emit(OverviewError('Failed to load documents: ${e.toString()}'));
    }
  }

  FutureOr<void> _onLoadMoreDocuments(
    LoadMoreDocuments event,
    Emitter<OverviewState> emit,
  ) async {
    if (state is! OverviewLoaded) return;

    final currentState = state as OverviewLoaded;

    // Don't load more if already loading or no more items
    if (currentState.isLoadingMore || !currentState.hasMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final nextQuery = currentState.currentQuery.copyWith(
        startAfterDocumentId: currentState.nextPageToken,
      );

      final result =
          await _legalDocumentRepository.getLegalDocuments(nextQuery);

      emit(currentState.copyWith(
        documents: [...currentState.documents, ...result.items],
        hasMore: result.hasMore,
        nextPageToken: result.nextPageToken,
        isLoadingMore: false,
      ));
    } catch (e) {
      emit(currentState.copyWith(
        isLoadingMore: false,
        errorMessage: 'Failed to load more documents: ${e.toString()}',
      ));
    }
  }

  FutureOr<void> _onRefreshDocuments(
    RefreshDocuments event,
    Emitter<OverviewState> emit,
  ) async {
    // Always use the current query to refresh, but reset pagination
    DocumentQuery refreshQuery = const DocumentQuery();
    if (state is OverviewLoaded) {
      final currentState = state as OverviewLoaded;
      refreshQuery = currentState.currentQuery.copyWith(
        startAfterDocumentId: null, // Reset pagination
      );
    }
    add(LoadLegalDocuments(refreshQuery));
  }

  FutureOr<void> _onSearchDocuments(
    SearchDocuments event,
    Emitter<OverviewState> emit,
  ) async {
    // Get the current filter type from the state if it's already loaded
    DocumentType? currentFilterType;
    if (state is OverviewLoaded) {
      currentFilterType = (state as OverviewLoaded).currentQuery.filterType;
    }

    final searchQuery = DocumentQuery(
      searchQuery: event.searchQuery,
      // Use the filterType from the event if provided, otherwise retain the current one
      filterType: event.filterType ?? currentFilterType,
      startAfterDocumentId: null, // Reset pagination on search
      limit: 5,
    );

    add(LoadLegalDocuments(searchQuery));
  }

  FutureOr<void> _onFilterDocuments(
    FilterDocuments event,
    Emitter<OverviewState> emit,
  ) async {
    DocumentQuery filterQuery;
    String? currentSearchQuery;

    if (state is OverviewLoaded) {
      final currentState = state as OverviewLoaded;
      currentSearchQuery = currentState.currentQuery.searchQuery;
      filterQuery = currentState.currentQuery.copyWith(
        filterType: event.filterType,
        searchQuery: currentSearchQuery, // Ensure search query is preserved
        startAfterDocumentId: null, // Reset pagination
      );
    } else {
      // If not in OverviewLoaded, create a new query with only the filter
      filterQuery = DocumentQuery(filterType: event.filterType);
    }

    add(LoadLegalDocuments(filterQuery));
  }

  void _onRequestDocumentExplanation(
    RequestDocumentExplanation event,
    Emitter<OverviewState> emit,
  ) {
    emit(ExplanationRequested(
      documentId: event.documentId,
      documentTitle: event.documentTitle,
    ));
  }
}
