import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';
import 'package:wakili/common/res/colors.dart';
import 'package:wakili/features/auth/data/models/intro_screen_model.dart';
import 'package:wakili/features/auth/presentation/pages/intro_screen_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wakili/common/widgets/split_color_button.dart'; // Import the new button widget

@RoutePage()
class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _buttonAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _buttonAnimationController,
      curve: Curves.easeInOut,
    ));

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.round() ?? 0;
      });
    });

    _buttonAnimationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    final List<IntroScreenContent> introContent = [
      IntroScreenContent(
        imageUrl: 'assets/images/intro1.png',
        title: 'Your Legal AI Companion',
        description:
            'Get instant answers and guidance on legal matters with our advanced AI.',
      ),
      IntroScreenContent(
        imageUrl: 'assets/images/intro2.png',
        title: 'Effortless Document Analysis',
        description:
            'Upload documents, highlight key points, and get summaries in seconds.',
      ),
      IntroScreenContent(
        imageUrl: 'assets/images/intro3.png',
        title: 'Always Up-to-Date',
        description:
            'Our AI is continuously updated with the latest legal information and regulations.',
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Enhanced background with subtle gradient overlay
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.visualDarkBackgroundHalf,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.visualDarkBackgroundHalf,
                        AppColors.visualDarkBackgroundHalf
                            .withValues(alpha: 0.95),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.visualLightBackgroundHalf,
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        AppColors.visualLightBackgroundHalf,
                        AppColors.visualLightBackgroundHalf
                            .withValues(alpha: 0.95),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Subtle center divider with glow effect
          Positioned(
            left: size.width / 2 - 0.5,
            top: 0,
            bottom: 0,
            child: Container(
              width: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.dividerColor.withValues(alpha: 0.15),
                    AppColors.dividerColor.withValues(alpha: 0.3),
                    AppColors.dividerColor.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: introContent.length,
                    itemBuilder: (context, index) {
                      return IntroScreenPage(
                        imageUrl: introContent[index].imageUrl,
                        title: introContent[index].title,
                        description: introContent[index].description,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 32),

                // Enhanced page indicator
                SmoothPageIndicator(
                  controller: _pageController,
                  count: introContent.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: isDarkMode
                        ? AppColors.brandAccent
                        : AppColors.brandPrimary,
                    dotColor: isDarkMode
                        ? AppColors.textOnPrimary.withValues(alpha: 0.25)
                        : AppColors.dividerColor.withValues(alpha: 0.3),
                    dotHeight: 10,
                    dotWidth: 10,
                    expansionFactor: 3,
                    spacing: 12,
                  ),
                ),

                const SizedBox(height: 48),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: AnimatedBuilder(
                    animation: _buttonAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _buttonAnimation.value,
                        child: SplitColorButton(
                          onPressed: () {
                            if (_currentPage < introContent.length - 1) {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOutCubic,
                              );
                            } else {
                              context.router.replace(const LoginRoute());
                            }
                          },
                          text: _currentPage < introContent.length - 1
                              ? 'Next'
                              : 'Get Started',
                          textStyle: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textOnPrimary,
                            letterSpacing: 0.5,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: (isDarkMode
                                      ? AppColors.brandAccent
                                      : AppColors.brandPrimary)
                                  .withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                          isPrimaryButton: true,
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                SplitColorButton(
                  onPressed: () {
                    context.router.replace(const LoginRoute());
                  },
                  text: _currentPage < introContent.length - 1
                      ? 'Skip'
                      : 'Already have an account?',
                  textStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.2,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 12.0,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  isPrimaryButton: false, 
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
