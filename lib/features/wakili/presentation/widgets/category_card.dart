import 'package:flutter/material.dart';
import 'package:wakili/common/helpers/base_usecase.dart'; // Assuming getImagePath is here
import 'package:wakili/features/wakili/data/models/legal_category.dart'; // Ensure this path is correct

class CategoryCard extends StatelessWidget {
  final LegalCategory category;
  final VoidCallback onTap;

  const CategoryCard({super.key, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final String imagePath = getImagePath(category.title);

    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
              borderRadius: BorderRadius.circular(16),
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
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        child: Center(
                          child: Icon(
                            Icons.broken_image,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Gradient Overlay - ADJUSTED FOR DARK MODE SHADOW
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          // Top color: Even more subtle in light mode, less opaque in dark mode
                          isDarkMode
                              ? Colors.black.withOpacity(0.2)
                              : Colors.black.withOpacity(
                                  0.05,
                                ), // Reduced dark mode top opacity
                          // Middle color: Category color with controlled opacity
                          category.color.withOpacity(
                            isDarkMode ? 0.5 : 0.3,
                          ), // Slightly reduced dark mode middle opacity
                          // Bottom color: Still provides good contrast, but slightly less opaque for dark mode
                          isDarkMode
                              ? Colors.black.withOpacity(0.7)
                              : Colors.black.withOpacity(
                                  0.6,
                                ), // Reduced dark mode bottom opacity slightly
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
                              color: Colors.white, // Keep white for readability
                            ),
                        textAlign: TextAlign.left,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Description
                      Text(
                        category.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white70, // Keep consistent
                          shadows: [
                            Shadow(
                              blurRadius: 4.0,
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(1.0, 1.0),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.left,
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
