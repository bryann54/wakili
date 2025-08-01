import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakili/features/wakili/data/models/legal_category.dart';
import 'package:wakili/features/wakili/presentation/widgets/category_card.dart';
import 'package:wakili/features/wakili/presentation/bloc/wakili_bloc.dart';
import 'package:wakili/features/wakili/presentation/widgets/shimmer/category_shimmer_grid_view.dart'; // Import the new shimmer grid
import 'package:wakili/features/wakili/presentation/widgets/shimmer/category_card_shimmer.dart'; // Import the individual card shimmer
import 'dart:math' as math;

class CategoryGridView extends StatefulWidget {
  final ValueChanged<LegalCategory> onCategorySelected;

  const CategoryGridView({
    super.key,
    required this.onCategorySelected,
  });

  @override
  State<CategoryGridView> createState() => _CategoryGridViewState();
}

class _CategoryGridViewState extends State<CategoryGridView>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final math.Random _random = math.Random();

  final Map<String, AnimationController> _controllers = {};
  final Map<String, Animation<Offset>> _slideAnimations = {};
  final Map<String, Animation<double>> _fadeAnimations = {};
  final Map<String, bool> _fromLeftMap = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _disposeAnimations();
    super.dispose();
  }

  void _disposeAnimations() {
    _controllers.forEach((key, controller) {
      controller.dispose();
    });
    _controllers.clear();
    _slideAnimations.clear();
    _fadeAnimations.clear();
    _fromLeftMap.clear();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final state = BlocProvider.of<WakiliBloc>(context).state;
      if (state is WakiliChatLoaded &&
          !state.isLoading &&
          state.hasMoreCategories) {
        BlocProvider.of<WakiliBloc>(context)
            .add(const LoadMoreLegalCategories());
      }
    }
  }

  void _setupAndStartAnimationForCategory(LegalCategory category) {
    if (!_controllers.containsKey(category.id)) {
      final controller = AnimationController(
        duration: Duration(milliseconds: 600 + (_random.nextInt(400))),
        vsync: this,
      );
      _controllers[category.id] = controller;

      final fromLeft = _random.nextBool();
      _fromLeftMap[category.id] = fromLeft;

      _slideAnimations[category.id] = Tween<Offset>(
        begin: Offset(fromLeft ? -1.5 : 1.5, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutCubic,
      ));

      _fadeAnimations[category.id] = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ));

      Future.delayed(
        Duration(milliseconds: _controllers.length * 100),
        () {
          if (mounted && _controllers.containsKey(category.id)) {
            _controllers[category.id]?.forward();
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WakiliBloc, WakiliState>(
      builder: (context, state) {
        List<LegalCategory> categories = [];
        bool isLoading = false;
        bool hasMore = false;
        String? error;

        if (state is WakiliChatLoaded) {
          categories = state.allCategories;
          isLoading = state.isLoading;
          hasMore = state.hasMoreCategories;
        } else if (state is WakiliChatErrorState) {
          categories = state.allCategories;
          error = state.message;
          isLoading = false;
          hasMore = state.hasMoreCategories;
        } else if (state is WakiliChatInitial) {
          isLoading = true;
        }

        for (final category in categories) {
          _setupAndStartAnimationForCategory(category);
        }

        _controllers.keys.toList().forEach((id) {
          if (!categories.any((cat) => cat.id == id)) {
            _controllers[id]?.dispose();
            _controllers.remove(id);
            _slideAnimations.remove(id);
            _fadeAnimations.remove(id);
            _fromLeftMap.remove(id);
          }
        });

        int effectiveItemCount = categories.length;
        if (hasMore && isLoading) {
          effectiveItemCount +=
              2; 
        } else if (hasMore && !isLoading && categories.isNotEmpty) {
          effectiveItemCount +=
              1; 
        }

        if (categories.isEmpty && isLoading) {
          return const CategoryShimmerGridView();
        }

        if (error != null && categories.isEmpty) {
          return Center(child: Text('Failed to load categories: $error'));
        }

        if (categories.isEmpty && !isLoading) {
          return const Center(child: Text('No legal categories found.'));
        }

        return MasonryGridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.only(bottom: 16),
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          itemCount: effectiveItemCount, 
          itemBuilder: (context, index) {
            final heights = [180.0, 220.0, 200.0, 240.0, 190.0, 210.0];
            final height = heights[index % heights.length];

            if (index < categories.length) {
              final category = categories[index];
              if (!_controllers.containsKey(category.id)) {
                _setupAndStartAnimationForCategory(category);
              }

              return AnimatedBuilder(
                animation: _controllers[category.id]!,
                builder: (context, child) {
                  return SlideTransition(
                    position: _slideAnimations[category.id]!,
                    child: FadeTransition(
                      opacity: _fadeAnimations[category.id]!,
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
            } else if (hasMore && isLoading) {
              return SizedBox(
                height: height,
                child: const CategoryCardShimmer(height: 100,),
              );
            } else if (hasMore &&
                !isLoading &&
                categories.isNotEmpty &&
                index == categories.length) {
              return const SizedBox.shrink(); 
            }
            return const SizedBox.shrink(); 
          },
        );
      },
    );
  }
}
