import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:wakili/common/res/l10n.dart';
import 'package:wakili/features/overview/domain/entities/legal_document.dart';
import 'package:wakili/features/overview/presentation/widgets/document_card.dart';
import '../bloc/overview_bloc.dart';

@RoutePage()
class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OverviewBloc()..add(const LoadLegalDocuments()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.getString(context, 'Legal Documents')),
        ),
        body: const _OverviewBody(),
      ),
    );
  }
}

class _OverviewBody extends StatelessWidget {
  const _OverviewBody();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OverviewBloc, OverviewState>(
      listener: (context, state) {
        if (state is ExplanationRequested) {
          _showExplanationDialog(context, state.documentTitle);
        }
      },
      builder: (context, state) {
        if (state is OverviewLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is OverviewError) {
          return Center(child: Text(state.message));
        }

        if (state is OverviewLoaded) {
          return state.documents.isEmpty
              ? const Center(child: Text('No documents found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.documents.length,
                  itemBuilder: (context, index) {
                    final document = state.documents[index];
                    return DocumentCard(
                      document: document,
                      onView: () => _showDocumentDetails(context, document),
                      onExplain: () => _requestExplanation(context, document),
                    );
                  },
                );
        }

        return const SizedBox();
      },
    );
  }

  void _showDocumentDetails(BuildContext context, LegalDocument document) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                document.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Text(document.summary),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _requestExplanation(context, document),
                  child: const Text('Explain with Wakili AI'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _requestExplanation(BuildContext context, LegalDocument document) {
    context.read<OverviewBloc>().add(
          RequestDocumentExplanation(
            documentId: document.id,
            documentTitle: document.title,
          ),
        );
  }

  void _showExplanationDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Wakili AI Explanation'),
        content: Text('Preparing explanation for "$title"...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
