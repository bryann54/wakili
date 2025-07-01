import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';
import 'package:wakili/features/wakili/data/models/legal_category.dart';
import 'package:wakili/features/wakili/presentation/bloc/wakili_bloc.dart';
import 'package:wakili/features/wakili/presentation/widgets/wakili_welcome_header.dart';
import 'package:wakili/features/wakili/presentation/widgets/wakili_search_bar.dart';
import 'package:wakili/features/wakili/presentation/widgets/category_grid_view.dart';

@RoutePage()
class WakiliChatScreen extends StatefulWidget {
  const WakiliChatScreen({super.key});

  @override
  State<WakiliChatScreen> createState() => _WakiliChatScreenState();
}

class _WakiliChatScreenState extends State<WakiliChatScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  String _searchQuery = '';

  final List<LegalCategory> _legalCategories = const [
    LegalCategory(
      title: 'Traffic Law',
      icon: Icons.directions_car,
      color: Colors.blue,
      description: 'Traffic violations, licenses, accidents',
    ),
    LegalCategory(
      title: 'Criminal Law',
      icon: Icons.security,
      color: Colors.red,
      description: 'Criminal offenses, procedures, rights',
    ),
    LegalCategory(
      title: 'Family Law',
      icon: Icons.family_restroom,
      color: Colors.purple,
      description: 'Marriage, divorce, custody, inheritance',
    ),
    LegalCategory(
      title: 'Employment',
      icon: Icons.work_outline,
      color: Colors.orange,
      description: 'Labor rights, contracts, disputes',
    ),
    LegalCategory(
      title: 'Property Law',
      icon: Icons.home_work,
      color: Colors.green,
      description: 'Real estate, land, property rights',
    ),
    LegalCategory(
      title: 'Business Law',
      icon: Icons.business_center,
      color: Colors.indigo,
      description: 'Company law, contracts, regulations',
    ),
    LegalCategory(
      title: 'Consumer Rights',
      icon: Icons.shopping_cart,
      color: Colors.teal,
      description: 'Consumer protection, warranties',
    ),
    LegalCategory(
      title: 'Constitutional',
      icon: Icons.account_balance,
      color: Colors.brown,
      description: 'Human rights, civil liberties',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onCategorySelected(LegalCategory category) {
    AutoRouter.of(context).push(CategoryChatRoute(category: category));
  }

  List<LegalCategory> get _filteredCategories {
    if (_searchQuery.isEmpty) return _legalCategories;
    return _legalCategories
        .where((category) =>
            category.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            category.description
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Wakili AI'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: BlocProvider(
        create: (context) => GetIt.instance<WakiliBloc>(),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              const WakiliWelcomeHeader(),
              const SizedBox(height: 14),
              WakiliSearchBar(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CategoryGridView(
                    categories: _filteredCategories,
                    onCategorySelected: _onCategorySelected,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
