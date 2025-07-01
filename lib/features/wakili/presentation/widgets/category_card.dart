import 'package:flutter/material.dart';
import 'package:wakili/common/helpers/base_usecase.dart';
import 'package:wakili/features/wakili/data/models/legal_category.dart'; // Ensure this path is correct

class CategoryCard extends StatelessWidget {
  final LegalCategory category;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String imagePath = getImagePath(category.title);

    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: 'category_card_${category.title}',
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: Stack(
              children: [
                // Background Image
                Positioned.fill(
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        child: Center(
                          child:
                              Icon(Icons.broken_image, color: Colors.grey[400]),
                        ),
                      );
                    },
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.3),
                          category.color.withValues(alpha: 0.5),
                          Colors.black.withValues(alpha: 0.7),
                        ],
                        stops: const [0.0, 0.6, 1.0],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.left, // Align text left
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Description
                      Text(
                        category.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white70, // Slightly transparent white
                          shadows: [
                            Shadow(
                              blurRadius: 4.0,
                              color: Colors.black.withValues(alpha: 0.5),
                              offset: const Offset(1.0, 1.0),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.left, // Align text left
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
