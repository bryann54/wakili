import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart'; 
import 'package:wakili/features/overview/domain/entities/legal_document.dart';
import 'package:wakili/features/overview/domain/repositories/legal_document_repository.dart'; // Import repository

part 'overview_event.dart';
part 'overview_state.dart';

@injectable 
class OverviewBloc extends Bloc<OverviewEvent, OverviewState> {
  final LegalDocumentRepository
      _legalDocumentRepository; 
  OverviewBloc(this._legalDocumentRepository) : super(OverviewInitial()) {
    on<LoadLegalDocuments>(_onLoadLegalDocuments);
    on<RefreshDocuments>(_onRefreshDocuments);
    on<RequestDocumentExplanation>(_onRequestDocumentExplanation);
  }

  FutureOr<void> _onLoadLegalDocuments(
      LoadLegalDocuments event, Emitter<OverviewState> emit) async {
    emit(OverviewLoading());

    try {
      final documents = await _legalDocumentRepository.getLegalDocuments(
        filterType: event.filterType,
        searchQuery: event.searchQuery,
      );

      emit(OverviewLoaded(
        documents: documents,
        currentFilter: event.filterType,
        currentSearch: event.searchQuery,
      ));
    } catch (e) {
      emit(OverviewError('Failed to load documents: ${e.toString()}'));
    }
  }

  FutureOr<void> _onRefreshDocuments(
      RefreshDocuments event, Emitter<OverviewState> emit) async {
    if (state is OverviewLoaded) {
      final currentState = state as OverviewLoaded;
      add(LoadLegalDocuments(
        filterType: currentState.currentFilter,
        searchQuery: currentState.currentSearch,
      ));
    } else {
      add(const LoadLegalDocuments());
    }
  }

  void _onRequestDocumentExplanation(
      RequestDocumentExplanation event, Emitter<OverviewState> emit) {
    emit(ExplanationRequested(
      documentId: event.documentId,
      documentTitle: event.documentTitle,
    ));
  }
}
