import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakili/features/overview/domain/entities/legal_document.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';

@RoutePage()
class DocumentDetailScreen extends StatelessWidget {
  final LegalDocument document;

  const DocumentDetailScreen({
    super.key,
    required this.document,
  });

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final DateFormat dateFormatter = DateFormat.yMMMMd();

    return Scaffold(
      appBar: AppBar(
        // Modified: Using document type in the AppBar's Hero
        title: Hero(
          tag: 'document-type-${document.id}', // Unique tag for the type Hero
          child: Material(
            type: MaterialType.transparency,
            child: Text(
              '${_getTypeDisplayName(document.type)} Details',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        backgroundColor: colors.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'document-${document.id}',
              child: Material(
                type: MaterialType.transparency,
                child: Text(
                  document.title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.onSurface,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    context,
                    Icons.calendar_today_outlined,
                    'Published:',
                    dateFormatter.format(document.datePublished),
                  ),
                  _buildDetailRow(
                    context,
                    Icons.info_outline,
                    'Status:',
                    document.status,
                  ),
                  _buildDetailRow(
                    context,
                    Icons.person_outline,
                    'Sponsor:',
                    document.sponsor,
                  ),
                  _buildDetailRow(
                    context,
                    Icons.account_tree_outlined,
                    'Stage:',
                    document.parliamentaryStage,
                  ),
                  if (document.sourceUrl != null &&
                      document.sourceUrl!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: GestureDetector(
                        onTap: () => _launchUrl(document.sourceUrl!),
                        child: Row(
                          children: [
                            Icon(Icons.link, size: 20, color: colors.primary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Source Link',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colors.primary,
                                  decoration: TextDecoration.underline,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Summary Section
            Text(
              'Summary',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              document.summary,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),

            // Full Content Section
            Text(
              'Full Content',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: colors.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              document.content,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),

            // Tags (as scrollable chips)
            if (document.tags.isNotEmpty) ...[
              Text(
                'Related Topics',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: document.tags.length,
                  itemBuilder: (context, index) {
                    final tag = document.tags[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Chip(
                        label: Text(tag),
                        backgroundColor:
                            colors.secondaryContainer.withValues(alpha: 0.5),
                        labelStyle: theme.textTheme.labelMedium?.copyWith(
                          color: colors.onSecondaryContainer,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                              color: colors.secondary.withValues(alpha: 0.2)),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
            ],

            // "Ask Wakili AI to Explain" Floating/Fixed Button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  context.router.push(
                    GeneralChatRoute(
                      initialMessage:
                          'Explain the ${document.type.name} titled "${document.title}" from the document details.',
                    ),
                  );
                },
                icon: const Icon(Icons.psychology_alt),
                label: const Text('Get AI Explanation'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon,
              size: 15, color: colors.onSurfaceVariant.withValues(alpha: 0.7)),
          const SizedBox(width: 12),
          Text(
            '$label ',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colors.onSurface,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to get display name for DocumentType (same as in DocumentCard)
  String _getTypeDisplayName(DocumentType type) {
    switch (type) {
      case DocumentType.bill:
        return 'Bill';
      case DocumentType.act:
        return 'Act';
      case DocumentType.law:
        return 'Law';
      case DocumentType.amendment:
        return 'Amendment';
      case DocumentType.regulation:
        return 'Regulation';
    }
  }
}
