import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';
import 'package:wakili/common/res/colors.dart';
import 'package:wakili/features/auth/data/models/intro_screen_model.dart';
import 'package:wakili/features/auth/presentation/pages/intro_screen_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async';

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

  // Autoplay variables
  Timer? _autoplayTimer;
  static const Duration _autoplayDuration = Duration(seconds: 4);
  bool _isAutoplayActive = true;
  bool _userInteracted = false;

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

    // Start autoplay
    _startAutoplay();
  }

  void _startAutoplay() {
    if (!_isAutoplayActive || _userInteracted) return;

    _autoplayTimer?.cancel();
    _autoplayTimer = Timer.periodic(_autoplayDuration, (timer) {
      if (!_isAutoplayActive || _userInteracted) {
        timer.cancel();
        return;
      }

      if (_currentPage < introContent.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      } else {
        // Reset to first page or stop autoplay
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _stopAutoplay() {
    setState(() {
      _isAutoplayActive = false;
      _userInteracted = true;
    });
    _autoplayTimer?.cancel();
  }

  void _onUserInteraction() {
    _stopAutoplay();
  }

  @override
  void dispose() {
    _autoplayTimer?.cancel();
    _pageController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  // Enhanced content with FontAwesome icons
  final List<IntroScreenContent> introContent = [
    IntroScreenContent(
      icon: FontAwesomeIcons.scaleBalanced, // Legal scales icon
      title: 'Your Legal AI Companion',
      description:
          'Get instant answers and guidance on legal matters with our advanced AI.',
    ),
    IntroScreenContent(
      icon: FontAwesomeIcons.receipt, // Legal document icon
      title: 'Effortless Document Analysis',
      description:
          'Upload documents, highlight key points, and get summaries in seconds.',
    ),
    IntroScreenContent(
      icon: FontAwesomeIcons.gavel, // Judge's gavel icon
      title: 'Always Up-to-Date',
      description:
          'Our AI is continuously updated with the latest legal information and regulations.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

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
                    Colors.grey.withValues(alpha: 0.15),
                    Colors.grey.withValues(alpha: 0.3),
                    Colors.grey.withValues(alpha: 0.15),
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

                // In your GetStartedScreen build method, replace the autoplay indicator with:
                if (_isAutoplayActive && !_userInteracted)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [Colors.black, Colors.white],
                                stops: const [0.5, 0.5],
                              ).createShader(bounds),
                              child: const Icon(
                                Icons.play_arrow,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [Colors.black, Colors.white],
                                stops: const [0.5, 0.5],
                              ).createShader(bounds),
                              child: Text(
                                'Auto-playing',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: _onUserInteraction,
                          child: ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [Colors.black, Colors.white],
                              stops: const [0.5, 0.5],
                            ).createShader(bounds),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                'Stop',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                if (_isAutoplayActive && !_userInteracted)
                  const SizedBox(height: 16),

                // Enhanced PageView
                Expanded(
                  child: GestureDetector(
                    onTap: _onUserInteraction,
                    onPanDown: (_) => _onUserInteraction(),
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: introContent.length,
                      onPageChanged: (index) {
                        if (!_userInteracted) {
                          _onUserInteraction();
                        }
                      },
                      itemBuilder: (context, index) {
                        return IntroScreenPage(
                          icon: introContent[index].icon,
                          title: introContent[index].title,
                          description: introContent[index].description,
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Enhanced page indicator with progress
                Column(
                  children: [
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: introContent.length,
                      effect: ExpandingDotsEffect(
                        activeDotColor: isDarkMode
                            ? AppColors.brandAccent
                            : AppColors.brandPrimary,
                        dotColor: isDarkMode
                            ? Colors.white.withValues(alpha: 0.25)
                            : Colors.grey.withValues(alpha: 0.3),
                        dotHeight: 10,
                        dotWidth: 10,
                        expansionFactor: 3,
                        spacing: 12,
                      ),
                    ),

                    // Progress indicator for autoplay
                    if (_isAutoplayActive && !_userInteracted)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Container(
                          width: 60,
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: TweenAnimationBuilder<double>(
                            duration: _autoplayDuration,
                            tween: Tween(begin: 0.0, end: 1.0),
                            builder: (context, value, _) {
                              return LinearProgressIndicator(
                                value: value,
                                backgroundColor: Colors.transparent,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isDarkMode
                                      ? AppColors.brandAccent
                                      : AppColors.brandPrimary,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 48),

                if (_currentPage < introContent.length - 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            _onUserInteraction();
                            context.router.replace(const LoginRoute());
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                              vertical: 12.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Skip',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isDarkMode
                                  ? AppColors.textSecondary
                                  : AppColors.textLightDark,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),

                        // Next button with rounded black forward icon
                        AnimatedBuilder(
                          animation: _buttonAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _buttonAnimation.value,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    _onUserInteraction();
                                    _pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeInOutCubic,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.all(16.0),
                                    shape: const CircleBorder(),
                                    elevation: 0,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                // Get Started button with split theme (only on last page)
                if (_currentPage == introContent.length - 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      children: [
                        // Skip button at top on last page
                        TextButton(
                          onPressed: () {
                            _onUserInteraction();
                            context.router.replace(const LoginRoute());
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                              vertical: 12.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Already have an account?',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isDarkMode
                                  ? AppColors.textLightDark
                                  : AppColors.textSecondary,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Split theme Get Started button
                        AnimatedBuilder(
                          animation: _buttonAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _buttonAnimation.value,
                              child: Container(
                                width: double.infinity,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.15),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Stack(
                                    children: [
                                      // Split background
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: isDarkMode
                                                    ? Colors.black
                                                    : Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      AnimatedBuilder(
                                        animation: _buttonAnimation,
                                        builder: (context, child) {
                                          return Transform.scale(
                                            scale: _buttonAnimation.value,
                                            child: Material(
                                              color: Colors.transparent,
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                onTap: () {
                                                  _onUserInteraction();
                                                  context.router.replace(
                                                      const LoginRoute());
                                                },
                                                splashColor: Colors.grey
                                                    .withValues(alpha: 0.1),
                                                highlightColor:
                                                    Colors.transparent,
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 56,
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 32),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withValues(
                                                                alpha: 0.1),
                                                        blurRadius: 12,
                                                        offset:
                                                            const Offset(0, 4),
                                                      ),
                                                    ],
                                                  ),
                                                  child: Stack(
                                                    children: [
                                                      // Background split
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: isDarkMode
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .horizontal(
                                                                  left: Radius
                                                                      .circular(
                                                                          12),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: isDarkMode
                                                                    ? Colors
                                                                        .black
                                                                    : Colors
                                                                        .white,
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .horizontal(
                                                                  right: Radius
                                                                      .circular(
                                                                          12),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      // Text content
                                                      Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      24),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  'GET',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right,
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: isDarkMode
                                                                        ? Colors
                                                                            .black
                                                                        : Colors
                                                                            .white,
                                                                    letterSpacing:
                                                                        1.2,
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                width: 1,
                                                                height: 24,
                                                                margin: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        12),
                                                                color: Colors
                                                                    .grey
                                                                    .withValues(
                                                                        alpha:
                                                                            0.4),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  'STARTED',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style: GoogleFonts
                                                                      .poppins(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: isDarkMode
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                    letterSpacing:
                                                                        1.2,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
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
