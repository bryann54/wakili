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
    final bool shouldShowFullLoading = !(state is OverviewLoaded &&
        event.query.startAfterDocumentId == null &&
        event.query.searchQuery == null &&
        event.query.filterType == null);

    if (shouldShowFullLoading) {
      emit(OverviewLoading());
    }

    final resultEither = await _legalDocumentRepository.getLegalDocuments(
      event.query,
    );

    resultEither.fold(
      (failure) => emit(OverviewError(failure.toString())),
      (result) {
        emit(OverviewLoaded(
          documents: result.items,
          hasMore: result.hasMore,
          nextPageToken: result.nextPageToken,
          currentQuery: event.query,
          isLoadingMore: false,
        ));
      },
    );
  }

  FutureOr<void> _onLoadMoreDocuments(
    LoadMoreDocuments event,
    Emitter<OverviewState> emit,
  ) async {
    if (state is! OverviewLoaded) return;

    final currentState = state as OverviewLoaded;

    if (currentState.isLoadingMore || !currentState.hasMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final nextQuery = currentState.currentQuery.copyWith(
      startAfterDocumentId: currentState.nextPageToken,
    );

    final resultEither =
        await _legalDocumentRepository.getLegalDocuments(nextQuery);

    resultEither.fold(
      (failure) => emit(currentState.copyWith(
        isLoadingMore: false,
        errorMessage: failure.toString(),
      )),
      (result) {
        emit(currentState.copyWith(
          documents: [...currentState.documents, ...result.items],
          hasMore: result.hasMore,
          nextPageToken: result.nextPageToken,
          isLoadingMore: false,
          errorMessage: null,
        ));
      },
    );
  }

  FutureOr<void> _onRefreshDocuments(
    RefreshDocuments event,
    Emitter<OverviewState> emit,
  ) async {
    DocumentQuery refreshQuery = const DocumentQuery();
    if (state is OverviewLoaded) {
      final currentState = state as OverviewLoaded;
      refreshQuery = currentState.currentQuery.copyWith(
        startAfterDocumentId: null,
      );
    }
    add(LoadLegalDocuments(refreshQuery));
  }

  FutureOr<void> _onSearchDocuments(
    SearchDocuments event,
    Emitter<OverviewState> emit,
  ) async {
    DocumentType? currentFilterType;
    if (state is OverviewLoaded) {
      currentFilterType = (state as OverviewLoaded).currentQuery.filterType;
    }

    final searchQuery = DocumentQuery(
      searchQuery: event.searchQuery,
      filterType: event.filterType ?? currentFilterType,
      startAfterDocumentId: null,
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
        searchQuery: currentSearchQuery,
        startAfterDocumentId: null,
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
