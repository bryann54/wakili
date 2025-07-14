import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wakili/features/wakili/presentation/widgets/shimmer/category_card_shimmer.dart';

class CategoryShimmerGridView extends StatelessWidget {
  const CategoryShimmerGridView({super.key});

  @override
  Widget build(BuildContext context) {
    final heights = [180.0, 220.0, 200.0, 240.0, 190.0, 210.0];

    return MasonryGridView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      itemCount: 6,
      itemBuilder: (context, index) {
        final height = heights[index % heights.length];
        return CategoryCardShimmer(height: height);
      },
    );
  }
}
