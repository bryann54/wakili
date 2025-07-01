import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wakili/features/wakili/data/models/legal_category.dart';
import 'package:wakili/features/wakili/presentation/widgets/category_card.dart';

class CategoryGridView extends StatelessWidget {
  final List<LegalCategory> categories;
  final ValueChanged<LegalCategory> onCategorySelected;

  const CategoryGridView({
    super.key,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final heights = [180.0, 220.0, 200.0, 240.0, 190.0, 210.0];
        final height = heights[index % heights.length];

        return SizedBox(
          height: height,
          child: CategoryCard(
            category: category,
            onTap: () => onCategorySelected(category),
          ),
        );
      },
    );
  }
}
