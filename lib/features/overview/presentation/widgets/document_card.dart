import 'package:flutter/material.dart';
import 'package:wakili/features/overview/domain/entities/legal_document.dart';

class DocumentCard extends StatefulWidget {
  final LegalDocument document;
  final VoidCallback onView;
  final VoidCallback onExplain;

  const DocumentCard({
    super.key,
    required this.document,
    required this.onView,
    required this.onExplain,
  });

  @override
  State<DocumentCard> createState() => _DocumentCardState();
}

class _DocumentCardState extends State<DocumentCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _rotateAnimation = Tween<double>(begin: 0, end: 2 * 3.14159).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colors.outlineVariant.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: widget.onView,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with type badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTypeBadge(context),
                  Icon(
                    Icons.chevron_right,
                    color: colors.onSurfaceVariant,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Document Title
              Text(
                widget.document.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.onSurface,
                ),
              ),
              const SizedBox(height: 8),

              // Summary
              Text(
                widget.document.summary,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),

              // Action buttons
              Row(
                children: [
                  OutlinedButton(
                    onPressed: widget.onView,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.visibility_outlined, size: 16),
                        SizedBox(width: 6),
                        Text('View'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: widget.onExplain,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(0, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: colors.primary,
                          child: const CircleAvatar(
                            radius: 10,
                            backgroundImage: AssetImage('assets/wak.png'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        AnimatedBuilder(
                          animation: _rotateAnimation,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _rotateAnimation.value,
                              child: const Icon(
                                Icons.auto_awesome,
                                size: 16,
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 8),
                        const Text('Explain'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeBadge(BuildContext context) {
    final theme = Theme.of(context);
    final typeColor = _getTypeColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: typeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: typeColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        widget.document.type.name.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: typeColor,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Color _getTypeColor() {
    switch (widget.document.type) {
      case DocumentType.act:
        return Colors.green;
      case DocumentType.bill:
        return Colors.blue;
      case DocumentType.law:
        return Colors.purple;
      case DocumentType.amendment:
        return Colors.orange;
      case DocumentType.regulation:
        return Colors.teal;
    }
  }
}
