import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:wakili/common/utils/date_utils.dart';
import 'package:wakili/common/utils/functions.dart';
import 'package:wakili/features/overview/domain/entities/legal_document.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';
import 'package:wakili/features/overview/presentation/widgets/wakili_ai_button.dart';

class DocumentCard extends StatelessWidget {
  final LegalDocument document;

  const DocumentCard({
    super.key,
    required this.document,
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
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const SizedBox(width: 80),
                            Expanded(
                              child: Text(
                                formatDateObj(document.datePublished),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colors.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Document Title (prominent)
                        Text(
                          document.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colors.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 3),

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

                        const SizedBox(height: 10),

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
                                      backgroundColor:
                                          colors.surfaceContainerHighest,
                                      labelStyle:
                                          theme.textTheme.labelSmall?.copyWith(
                                        color: colors.onSurfaceVariant,
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 10),
                        ],

                        // AI Explanation Button
                        SizedBox(
                          width: double.infinity,
                          child: WakiliAiButton(
                            initialMessage:
                                'can you explain the ${document.type.name} titled "${document.title}" as found on the document card.',
                            isFilled: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Banner-style type badge
                _buildBannerTypeBadge(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBannerTypeBadge(BuildContext context) {
    final theme = Theme.of(context);
    final typeColor = getTypeColor(document.type);
    final typeName = getTypeDisplayName(document.type);

    return Positioned(
      top: 0,
      left: 0,
      child: ClipPath(
        clipper: BannerClipper(),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                typeColor,
                typeColor.withValues(alpha: 0.8),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: typeColor.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 8,
              left: 8,
              right: 20,
              bottom: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 2),
                Flexible(
                  child: Text(
                    typeName,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom clipper for creating the banner diagonal cut
class BannerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 20); // Left side
    path.lineTo(size.width - 10, 0); // Diagonal cut
    path.lineTo(size.width, 0); // Top right
    path.lineTo(0, 0); // Top left
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
