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
    emit(OverviewLoading());

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
    if (state is OverviewLoaded) {
      final currentState = state as OverviewLoaded;

      // Reset pagination for refresh
      final refreshQuery = currentState.currentQuery.copyWith(
        startAfterDocumentId: null,
      );

      add(LoadLegalDocuments(refreshQuery));
    } else {
      add(LoadLegalDocuments(const DocumentQuery()));
    }
  }

  FutureOr<void> _onSearchDocuments(
    SearchDocuments event,
    Emitter<OverviewState> emit,
  ) async {
    final searchQuery = DocumentQuery(
      searchQuery: event.searchQuery,
      filterType: event.filterType,
      limit: 5,
    );

    add(LoadLegalDocuments(searchQuery));
  }

  FutureOr<void> _onFilterDocuments(
    FilterDocuments event,
    Emitter<OverviewState> emit,
  ) async {
    DocumentQuery filterQuery;

    if (state is OverviewLoaded) {
      final currentState = state as OverviewLoaded;
      filterQuery = currentState.currentQuery.copyWith(
        filterType: event.filterType,
        startAfterDocumentId: null, // Reset pagination
      );
    } else {
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
