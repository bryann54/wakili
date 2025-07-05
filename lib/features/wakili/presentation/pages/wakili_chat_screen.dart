import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
  final TextEditingController _messageController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  String _searchQuery = '';
  bool _isLoading = false;

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
    _messageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onCategorySelected(LegalCategory category) {
    AutoRouter.of(context).push(CategoryChatRoute(category: category));
  }

  List<LegalCategory> get _filteredCategories {
    if (_searchQuery.isEmpty) return _legalCategories;
    return _legalCategories
        .where(
          (category) =>
              category.title.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ||
              category.description.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ),
        )
        .toList();
  }

  void _showChatInputModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildChatInputModal(),
    );
  }

  Widget _buildChatInputModal() {
    return StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundImage: AssetImage('assets/dp.png'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Ask Wakili',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const Spacer(),
                    // Speech-to-text indicator
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.mic,
                            size: 16,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                          const SizedBox(width: 4),
                          // Text(
                          //   'Voice supported',
                          //   style: Theme.of(context)
                          //       .textTheme
                          //       .labelSmall
                          //       ?.copyWith(
                          //         color: Theme.of(context)
                          //             .colorScheme
                          //             .onPrimaryContainer,
                          //         fontWeight: FontWeight.w500,
                          //       ),
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Chat input with mic button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Mic button
                      GestureDetector(
                        onTap: () => _handleSpeechToText(setModalState),
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.mic,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 20,
                          ),
                        ),
                      ),

                      // Text input field
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText:
                                'Ask wakili any legal related question...',
                            hintStyle: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          maxLines: null,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _sendMessage(setModalState),
                        ),
                      ),

                      // Send button
                      if (_messageController.text.trim().isNotEmpty ||
                          _isLoading)
                        GestureDetector(
                          onTap: _isLoading
                              ? null
                              : () => _sendMessage(setModalState),
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _isLoading
                                  ? Theme.of(context).colorScheme.outline
                                  : Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: _isLoading
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).colorScheme.onPrimary,
                                      ),
                                    ),
                                  )
                                : Icon(
                                    Icons.send,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    size: 20,
                                  ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // Add this method to your _WakiliChatScreenState class
  void _handleSpeechToText(StateSetter setModalState) async {
    // TODO: Implement speech-to-text functionality
    // For now, show a placeholder message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.mic,
              color: Theme.of(context).colorScheme.onInverseSurface,
            ),
            const SizedBox(width: 8),
            const Text('Speech-to-text feature coming soon!'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    // Example implementation when you're ready to integrate speech-to-text:
    /*
  try {
    bool available = await speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    
    if (available) {
      setModalState(() {
        _isListening = true;
      });
      
      speech.listen(
        onResult: (val) => setModalState(() {
          _messageController.text = val.recognizedWords;
        }),
      );
    }
  } catch (e) {
    print('Speech recognition error: $e');
  }
  */
  }

  void _sendMessage(StateSetter setModalState) async {
    if (_messageController.text.trim().isEmpty) return;

    final message = _messageController.text.trim();

    setModalState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        Navigator.of(context).pop();
        AutoRouter.of(context).push(GeneralChatRoute(initialMessage: message));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to process message: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setModalState(() {
          _isLoading = false;
        });
        _messageController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => GetIt.instance<WakiliBloc>(),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              const SizedBox(height: 55),
              const WakiliWelcomeHeader(),
              const SizedBox(height: 14),
              WakiliSearchBar(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
                  .animate()
                  .slideX(begin: 1, end: 0, curve: Curves.easeOut)
                  .fadeIn(duration: 500.ms, delay: 500.ms),
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
      floatingActionButton: GestureDetector(
        onTap: _showChatInputModal,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutQuint,
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.tertiary,
              ],
              transform: const GradientRotation(0.785),
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 12,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('assets/dp.png'),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary,
                        letterSpacing: 0.5,
                      ),
                  children: const [
                    TextSpan(text: 'Ask '),
                    TextSpan(
                      text: 'Wakili',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
