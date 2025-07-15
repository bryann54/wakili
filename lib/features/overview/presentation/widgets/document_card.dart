import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:intl/intl.dart';
import 'package:wakili/features/overview/domain/entities/legal_document.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';

class DocumentCard extends StatelessWidget {
  final LegalDocument document;
  final VoidCallback onExplain; 

  const DocumentCard({
    super.key,
    required this.document,
    required this.onExplain,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Hero(
      tag: 'document-${document.id}',
      child: Material(
        type: MaterialType.transparency,
        child: Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 1,
          color: colors.surfaceContainerLow,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              context.router.push(DocumentDetailRoute(document: document));
            },
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTypeChip(context),
                      Text(
                        _formatDate(document.datePublished),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Document Title (prominent)
                  Text(
                    document.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colors.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Summary (more subtle)
                  Text(
                    document.summary,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),

                  // Tags (if any)
                  if (document.tags.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: document.tags
                          .take(3)
                          .map((tag) => Chip(
                                label: Text(tag),
                                visualDensity: VisualDensity.compact,
                                backgroundColor: colors.surfaceVariant,
                                labelStyle:
                                    theme.textTheme.labelSmall?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // AI Explanation Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        context.router.push(
                          GeneralChatRoute(
                            initialMessage:
                                'Explain the ${document.type.name} titled "${document.title}" as found on the document card.',
                          ),
                        );
                  
                        // onExplain();
                      },
                      icon: Icon(Icons.auto_awesome,
                          size: 20, color: colors.primary),
                      label: Text(
                        'Ask Wakili AI',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                            // Corrected: withValues to withOpacity
                            color: colors.primary.withValues(alpha: 0.5)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip(BuildContext context) {
    final theme = Theme.of(context);
    return Chip(
      label: Text(
        _getTypeDisplayName(document.type),
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: _getTypeColor(document.type),
        ),
      ),
      backgroundColor:
          // Corrected: withValues to withOpacity
          _getTypeColor(document.type).withValues(alpha: 0.15),
      labelPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      visualDensity: VisualDensity.compact,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
            // Corrected: withValues to withOpacity
            color: _getTypeColor(document.type).withValues(alpha: 0.3)),
      ),
    );
  }

  Color _getTypeColor(DocumentType type) {
    switch (type) {
      case DocumentType.bill:
        return Colors.blue.shade700;
      case DocumentType.act:
        return Colors.green.shade700;
      case DocumentType.law:
        return Colors.purple.shade700;
      case DocumentType.amendment:
        return Colors.orange.shade700;
      case DocumentType.regulation:
        return Colors.teal.shade700;
    }
  }

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

  String _formatDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }
}
