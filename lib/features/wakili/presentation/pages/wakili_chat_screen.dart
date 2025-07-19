// features/wakili/presentation/screens/wakili_chat_screen.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';
import 'package:wakili/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:wakili/features/wakili/data/models/legal_category.dart';
import 'package:wakili/features/wakili/presentation/bloc/wakili_bloc.dart';
import 'package:wakili/features/wakili/presentation/widgets/chat_input_field.dart';
import 'package:wakili/features/wakili/presentation/widgets/shimmer/category_shimmer_grid_view.dart';
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

  List<LegalCategory> _getFilteredCategories(
      List<LegalCategory> allCategories) {
    if (_searchQuery.isEmpty) return allCategories;
    return allCategories
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
                      child: const CircleAvatar(
                        // Added const
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
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ChatInputField(
                messageController: _messageController,
                onSendMessage: () => _sendMessage(setModalState),
                hintText: 'Ask wakili any legal related question...',
                isLoading: _isLoading,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
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
        // This will now push to the GeneralChatScreen which includes the PopScope and WidgetsBindingObserver
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
        child: BlocConsumer<WakiliBloc, WakiliState>(
          listener: (context, state) {
            if (state is WakiliChatErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
          },
          builder: (context, wakiliState) {
            String? firstName;
            final authState = context
                .watch<AuthBloc>()
                .state; // Use context.watch for AuthState
            if (authState is AuthAuthenticated) {
              firstName = authState.user.displayName?.split(' ').first;
            }

            List<LegalCategory> categories = [];
            bool isLoading = false;

            if (wakiliState is WakiliChatLoaded) {
              categories = _getFilteredCategories(wakiliState.allCategories);
              isLoading = wakiliState.isLoading;
            } else if (wakiliState is WakiliChatErrorState) {
              categories = _getFilteredCategories(wakiliState.allCategories);
              isLoading = false;
            }

            return FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  const SizedBox(height: 55),
                  WakiliWelcomeHeader(firstName: firstName),
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
                      child: categories.isEmpty && isLoading
                          ? const CategoryShimmerGridView()
                          : categories.isEmpty && !isLoading
                              ? Center(
                                  child: Text(
                                    'No categories found.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                        ),
                                  ),
                                )
                              : CategoryGridView(
                                  categories: categories,
                                  onCategorySelected: _onCategorySelected,
                                ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: Builder(builder: (context) {
        // No direct save logic needed here, just UI.
        // final state = context.watch<WakiliBloc>().state;
        // if (state is WakiliChatLoaded) {}

        return GestureDetector(
          onTap: () => _showChatInputModal(),
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
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.3), // Corrected alpha usage
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
                    key:
                        ValueKey('dp_avatar'), // Added key for AnimatedSwitcher
                    radius: 18,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: const CircleAvatar(
                      // Added const
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
        );
      }),
    );
  }
}
