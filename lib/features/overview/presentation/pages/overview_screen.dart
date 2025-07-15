import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:get_it/get_it.dart'; // Import GetIt
import 'package:wakili/common/res/l10n.dart';
import 'package:wakili/features/overview/domain/entities/legal_document.dart';
import 'package:wakili/features/overview/presentation/widgets/document_card.dart';
import '../bloc/overview_bloc.dart';
import 'dart:math' as math;

@RoutePage()
class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<OverviewBloc>()..add(const LoadLegalDocuments()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
          scrolledUnderElevation: 1,
          title: Row(
            children: [
              // App icon or logo
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.balance,
                  size: 27,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 12),
              // Title
              Expanded(
                child: Text(
                  AppLocalizations.getString(context, 'Wakili\'s legal docs'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
            ],
          ),
          actions: [
            // Search button
            IconButton(
              onPressed: () {
                // TODO: Implement search functionality
              },
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withOpacity(0.5), // Corrected: withValues to withOpacity
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.search,
                  size: 27,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              tooltip: 'Search documents',
            ),
            // Filter/Menu button
            IconButton(
              onPressed: () {
                // TODO: Implement filter/menu functionality
              },
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withOpacity(0.5), // Corrected: withValues to withOpacity
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.tune,
                  size: 27,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              tooltip: 'Filter documents',
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: const _OverviewBody(),
      ),
    );
  }
}

class _OverviewBody extends StatefulWidget {
  const _OverviewBody();

  @override
  State<_OverviewBody> createState() => _OverviewBodyState();
}

class _OverviewBodyState extends State<_OverviewBody>
    with TickerProviderStateMixin {
  late AnimationController _loadingController;
  late AnimationController _listController;
  late Animation<double> _loadingAnimation;
  late Animation<double> _listFadeAnimation;
  late Animation<Offset> _listSlideAnimation;

  List<AnimationController> _itemControllers = [];
  List<Animation<double>> _itemScaleAnimations = [];
  List<Animation<double>> _itemFadeAnimations = [];
  List<Animation<Offset>> _itemSlideAnimations = [];

  final math.Random _random = math.Random();
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();

    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _listController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOut,
    ));

    _listFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _listController,
      curve: Curves.easeOut,
    ));

    _listSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _listController,
      curve: Curves.easeOutCubic,
    ));

    _loadingController.forward();
  }

  void _initializeItemAnimations(int itemCount) {
    if (_hasAnimated) return;

    _itemControllers = List.generate(itemCount, (index) {
      return AnimationController(
        duration: Duration(milliseconds: 600 + _random.nextInt(400)),
        vsync: this,
      );
    });

    _itemScaleAnimations = List.generate(itemCount, (index) {
      return Tween<double>(
        begin: 0.8,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _itemControllers[index],
        curve: Curves.elasticOut,
      ));
    });

    _itemFadeAnimations = List.generate(itemCount, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _itemControllers[index],
        curve: Curves.easeOut,
      ));
    });

    _itemSlideAnimations = List.generate(itemCount, (index) {
      // Alternate between sliding from left and right
      final isLeft = index % 2 == 0;
      return Tween<Offset>(
        begin: Offset(isLeft ? -1.2 : 1.2, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _itemControllers[index],
        curve: Curves.easeOutCubic,
      ));
    });

    _hasAnimated = true;
  }

  void _startItemAnimations() {
    _listController.forward();

    for (int i = 0; i < _itemControllers.length; i++) {
      Future.delayed(
        Duration(milliseconds: 150 + (i * 80)), // Staggered delay
        () {
          if (mounted) {
            _itemControllers[i].forward();
          }
        },
      );
    }
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _listController.dispose();
    for (final controller in _itemControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OverviewBloc, OverviewState>(
      listener: (context, state) {
        if (state is ExplanationRequested) {
          _showExplanationDialog(context, state.documentTitle);
        }

        if (state is OverviewLoaded && !_hasAnimated) {
          _initializeItemAnimations(state.documents.length);
          // Delay to show loading animation first
          Future.delayed(const Duration(milliseconds: 800), () {
            if (mounted) {
              _startItemAnimations();
            }
          });
        }
      },
      builder: (context, state) {
        if (state is OverviewLoading) {
          return Center(
            child: AnimatedBuilder(
              animation: _loadingAnimation,
              builder: (context, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.scale(
                      scale: 0.8 + (_loadingAnimation.value * 0.2),
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FadeTransition(
                      opacity: _loadingAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.5),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _loadingController,
                          curve: Curves.easeOut,
                        )),
                        child: Text(
                          'Loading legal documents...',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.7), // Corrected: withValues to withOpacity
                                  ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }

        if (state is OverviewError) {
          return Center(
            child: FadeTransition(
              opacity: _listFadeAnimation,
              child: SlideTransition(
                position: _listSlideAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (state is OverviewLoaded) {
          if (state.documents.isEmpty) {
            return Center(
              child: FadeTransition(
                opacity: _listFadeAnimation,
                child: SlideTransition(
                  position: _listSlideAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 64,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.3), // Corrected: withValues to withOpacity
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No documents found',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.7), // Corrected: withValues to withOpacity
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return FadeTransition(
            opacity: _listFadeAnimation,
            child: SlideTransition(
              position: _listSlideAnimation,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.documents.length,
                itemBuilder: (context, index) {
                  final document = state.documents[index];

                  if (index >= _itemControllers.length) {
                    // Fallback for items that don't have animations
                    return DocumentCard(
                      document: document,
                      onExplain: () => _requestExplanation(context, document),
                    );
                  }

                  return AnimatedBuilder(
                    animation: _itemControllers[index],
                    builder: (context, child) {
                      return SlideTransition(
                        position: _itemSlideAnimations[index],
                        child: FadeTransition(
                          opacity: _itemFadeAnimations[index],
                          child: ScaleTransition(
                            scale: _itemScaleAnimations[index],
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: DocumentCard(
                                document: document,
                                onExplain: () =>
                                    _requestExplanation(context, document),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }

  void _requestExplanation(BuildContext context, LegalDocument document) {
    context.read<OverviewBloc>().add(
          RequestDocumentExplanation(
            documentId: document.id,
            documentTitle: document.title,
          ),
        );
  }

  void _showExplanationDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Wakili AI Explanation'),
        content: Text('Preparing explanation for "$title"...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}