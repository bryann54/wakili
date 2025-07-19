import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wakili/features/wakili/data/models/legal_category.dart';
import 'package:wakili/features/wakili/presentation/widgets/category_card.dart';
import 'dart:math' as math;

class CategoryGridView extends StatefulWidget {
  final List<LegalCategory> categories;
  final ValueChanged<LegalCategory> onCategorySelected;

  const CategoryGridView({
    super.key,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  State<CategoryGridView> createState() => _CategoryGridViewState();
}

class _CategoryGridViewState extends State<CategoryGridView>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;
  late List<bool> _fromLeft;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _controllers = List.generate(
      widget.categories.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 600 + (_random.nextInt(400))),
        vsync: this,
      ),
    );

    _fromLeft = List.generate(
      widget.categories.length,
      (index) => _random.nextBool(),
    );

    _slideAnimations = List.generate(
      widget.categories.length,
      (index) => Tween<Offset>(
        begin: Offset(_fromLeft[index] ? -1.5 : 1.5, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _controllers[index],
        curve: Curves.easeOutCubic,
      )),
    );

    _fadeAnimations = List.generate(
      widget.categories.length,
      (index) => Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _controllers[index],
        curve: Curves.easeInOut,
      )),
    );
  }

  void _startAnimations() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(
        Duration(milliseconds: i * 120),
        () {
          if (mounted) {
            _controllers[i].forward();
          }
        },
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      itemCount: widget.categories.length,
      itemBuilder: (context, index) {
        final category = widget.categories[index];
        final heights = [180.0, 220.0, 200.0, 240.0, 190.0, 210.0];
        final height = heights[index % heights.length];

        return AnimatedBuilder(
          animation: _controllers[index],
          builder: (context, child) {
            return SlideTransition(
              position: _slideAnimations[index],
              child: FadeTransition(
                opacity: _fadeAnimations[index],
                child: SizedBox(
                  height: height,
                  child: CategoryCard(
                    category: category,
                    onTap: () => widget.onCategorySelected(category),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
