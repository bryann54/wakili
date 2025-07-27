// get_started_screen.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';
import 'package:wakili/features/auth/presentation/pages/intro_screen_page.dart';
import 'package:wakili/features/auth/presentation/widgets/getstarted/intro_screen_controller.dart';
import 'package:wakili/features/auth/presentation/widgets/getstarted/intro_background.dart';
import 'package:wakili/features/auth/presentation/widgets/getstarted/autoplay_indicator.dart';
import 'package:wakili/features/auth/presentation/widgets/getstarted/intro_page_indicator.dart';
import 'package:wakili/features/auth/presentation/widgets/getstarted/intro_navigation.dart';
import 'package:wakili/features/auth/presentation/widgets/getstarted/intro_content_data.dart';

@RoutePage()
class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen>
    with TickerProviderStateMixin {
  late IntroScreenController _controller;

  @override
  void initState() {
    super.initState();
    _controller = IntroScreenController(
      vsync: this,
      onNavigateToLogin: () => context.router.replace(const LoginRoute()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const IntroBackground(),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Autoplay indicator
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return AutoplayIndicator(
                      isVisible: _controller.isAutoplayActive &&
                          !_controller.userInteracted,
                      onStop: _controller.onUserInteraction,
                    );
                  },
                ),

                // PageView
                Expanded(
                  child: GestureDetector(
                    onTap: _controller.onUserInteraction,
                    onPanDown: (_) => _controller.onUserInteraction(),
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return PageView.builder(
                          controller: _controller.pageController,
                          itemCount: IntroContentData.introContent.length,
                          onPageChanged: (index) {
                            if (!_controller.userInteracted) {
                              _controller.onUserInteraction();
                            }
                          },
                          itemBuilder: (context, index) {
                            final content =
                                IntroContentData.introContent[index];
                            return IntroScreenPage(
                              icon: content.icon,
                              title: content.title,
                              description: content.description,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Page indicator
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return IntroPageIndicator(
                      pageController: _controller.pageController,
                      itemCount: IntroContentData.introContent.length,
                      showAutoplayProgress: _controller.isAutoplayActive &&
                          !_controller.userInteracted,
                      autoplayDuration: _controller.autoplayDuration,
                    );
                  },
                ),

                const SizedBox(height: 48),

                // Navigation buttons
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return IntroNavigation(
                      currentPage: _controller.currentPage,
                      totalPages: IntroContentData.introContent.length,
                      buttonAnimation: _controller.buttonAnimation,
                      onSkip: _controller.onNavigateToLogin,
                      onNext: () {
                        _controller.onUserInteraction();
                        _controller.pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOutCubic,
                        );
                      },
                      onGetStarted: _controller.onNavigateToLogin,
                    );
                  },
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
