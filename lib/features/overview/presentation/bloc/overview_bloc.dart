import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:wakili/features/overview/domain/entities/legal_document.dart';

part 'overview_event.dart';
part 'overview_state.dart';

class OverviewBloc extends Bloc<OverviewEvent, OverviewState> {
  OverviewBloc() : super(OverviewInitial()) {
    on<LoadLegalDocuments>(_onLoadLegalDocuments);
    on<RefreshDocuments>(_onRefreshDocuments);
    on<RequestDocumentExplanation>(_onRequestDocumentExplanation);
  }

  FutureOr<void> _onLoadLegalDocuments(
      LoadLegalDocuments event, Emitter<OverviewState> emit) async {
    emit(OverviewLoading());

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 800));
      final documents = _getMockDocuments();

      var filteredDocuments = documents;

      if (event.filterType != null) {
        filteredDocuments =
            documents.where((doc) => doc.type == event.filterType).toList();
      }

      if (event.searchQuery != null && event.searchQuery!.isNotEmpty) {
        filteredDocuments = filteredDocuments
            .where((doc) =>
                doc.title
                    .toLowerCase()
                    .contains(event.searchQuery!.toLowerCase()) ||
                doc.summary
                    .toLowerCase()
                    .contains(event.searchQuery!.toLowerCase()))
            .toList();
      }

      emit(OverviewLoaded(
        documents: filteredDocuments,
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

  List<LegalDocument> _getMockDocuments() {
    return [
      LegalDocument(
        id: '1',
        title: 'Data Protection Act, 2019',
        summary:
            'An Act to give effect to Article 31(c) and (d) of the Constitution; to regulate the processing of personal data; to provide for the rights of data subjects and regulation of data controllers and data processors.',
        content: 'Full content of the Data Protection Act...',
        type: DocumentType.act,
        datePublished: DateTime(2019, 11, 25),
        status: 'Enacted',
        tags: ['data protection', 'privacy', 'technology'],
        parliamentaryStage: 'Assented',
        sponsor: 'Ministry of ICT',
      ),
      LegalDocument(
        id: '2',
        title: 'Computer Misuse and Cybercrimes Act, 2018',
        summary:
            'An Act to provide for offences relating to computer misuse; to enable timely and effective detection, prohibition, prevention, response, investigation and prosecution of computer and cybercrimes.',
        content: 'Full content of the Computer Misuse and Cybercrimes Act...',
        type: DocumentType.act,
        datePublished: DateTime(2018, 5, 16),
        status: 'Enacted',
        tags: ['cybercrime', 'computer misuse', 'technology'],
        parliamentaryStage: 'Assented',
        sponsor: 'Ministry of ICT',
      ),
      LegalDocument(
        id: '3',
        title: 'Public Participation Bill, 2024',
        summary:
            'A Bill to provide a framework for public participation in policy formulation, legislative processes, and decision-making by public entities.',
        content: 'Full content of the Public Participation Bill...',
        type: DocumentType.bill,
        datePublished: DateTime(2024, 1, 15),
        status: 'Under Review',
        tags: ['public participation', 'governance', 'democracy'],
        parliamentaryStage: 'Second Reading',
        sponsor: 'Senate',
      ),
      LegalDocument(
        id: '4',
        title: 'Climate Change Act, 2016',
        summary:
            'An Act to provide for a regulatory framework for enhanced response to climate change; to provide for mechanisms and measures to achieve low carbon climate development.',
        content: 'Full content of the Climate Change Act...',
        type: DocumentType.act,
        datePublished: DateTime(2016, 8, 3),
        status: 'Enacted',
        tags: ['climate change', 'environment', 'sustainability'],
        parliamentaryStage: 'Assented',
        sponsor: 'Ministry of Environment',
      ),
      LegalDocument(
        id: '5',
        title: 'Digital Economy Blueprint Implementation Bill, 2024',
        summary:
            'A Bill to provide framework for the implementation of Kenya\'s digital economy blueprint and establish digital infrastructure development.',
        content:
            'Full content of the Digital Economy Blueprint Implementation Bill...',
        type: DocumentType.bill,
        datePublished: DateTime(2024, 2, 20),
        status: 'Under Review',
        tags: ['digital economy', 'technology', 'infrastructure'],
        parliamentaryStage: 'First Reading',
        sponsor: 'Ministry of ICT',
      ),
    ];
  }
}
