import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakili/features/overview/presentation/bloc/overview_bloc.dart';
import 'package:wakili/features/overview/presentation/widgets/document_card_shimmer.dart';

import 'document_card.dart';

class DocumentList extends StatelessWidget {
  final ScrollController scrollController;

  const DocumentList({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OverviewBloc, OverviewState>(
      builder: (context, state) {
        if (state is OverviewLoaded) {
          return RefreshIndicator.adaptive(
            onRefresh: () async {
              context.read<OverviewBloc>().add(const RefreshDocuments());
            },
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: state.documents.length + (state.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.documents.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: DocumentCardShimmer(),
                  );
                }
                final document = state.documents[index];
                return DocumentCard(
                  document: document,
                );
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
