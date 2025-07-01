import 'package:flutter/material.dart';
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
    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return CategoryCard(
          category: category,
          onTap: () => onCategorySelected(category),
        );
      },
    );
  }
}
