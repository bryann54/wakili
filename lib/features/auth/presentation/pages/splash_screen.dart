// lib/features/auth/presentation/pages/splash_screen.dart
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';
import 'package:wakili/features/auth/presentation/bloc/auth_bloc.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _backgroundFadeAnimation;
  late Animation<double> _titleSlideAnimation;
  late Animation<double> _subtitleSlideAnimation;
  bool _authCheckComplete = false;
  bool _animationComplete = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _checkAuth();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.6, curve: Curves.easeOutBack),
      ),
    );

    // Fade animation for logo and text
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    // Background fade animation
    _backgroundFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    // Text slide animations
    _titleSlideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _subtitleSlideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 0.9, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward().then((_) {
      setState(() {
        _animationComplete = true;
      });
      _navigateBasedOnAuth();
    });
  }

  Future<void> _checkAuth() async {
    // Dispatch AuthCheckStatus when the splash screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(AuthCheckStatus());
    });
  }

  void _navigateBasedOnAuth() {
    if (_authCheckComplete && _animationComplete) {
      // Navigation is handled by BlocListener
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // User is authenticated, navigate to the main app (MainRoute)
          context.router.replace(const MainRoute());
        } else if (state is AuthUnauthenticated) {
          // User is not authenticated, navigate to the login screen
          context.router.replace(const LoginRoute());
        } else if (state is AuthError) {
          // Handle error, e.g., show a snackbar or navigate to an error screen
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Authentication Error: ${state.message}')),
          );
          context.router.replace(const LoginRoute());
        }
        setState(() {
          _authCheckComplete = true;
        });
        _navigateBasedOnAuth();
      },
      child: Scaffold(
        body: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Stack(
              fit: StackFit.expand,
              children: [
                // Gradient background
                Opacity(
                  opacity: _backgroundFadeAnimation.value,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue,
                          Color(0xFF1E3A8A), // Darker shade for depth
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),

                // Animated circular patterns for visual interest
                Positioned(
                  top: -50,
                  right: -100,
                  child: Opacity(
                    opacity: 0.15 * _backgroundFadeAnimation.value,
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [Colors.white, Colors.white.withOpacity(0)],
                          stops: const [0.1, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -80,
                  left: -50,
                  child: Opacity(
                    opacity: 0.1 * _backgroundFadeAnimation.value,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [Colors.white, Colors.white.withOpacity(0)],
                          stops: const [0.1, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),

                // Main Content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo container with Wakili logo
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: ScaleTransition(
                          scale: _logoScaleAnimation,
                          child: Hero(
                            tag: 'app_logo',
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 30,
                                    offset: const Offset(0, 15),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.asset(
                                  'assets/wak.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Title with animation
                      Transform.translate(
                        offset: Offset(0, _titleSlideAnimation.value),
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: _buildTitle('Wakili'),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Subtitle with animation
                      Transform.translate(
                        offset: Offset(0, _subtitleSlideAnimation.value),
                        child: Opacity(
                          opacity: _fadeAnimation.value,
                          child: _buildSubtitle('Your Legal Assistant'),
                        ),
                      ),
                    ],
                  ),
                ),

                // Loading Indicator
                if (!_authCheckComplete)
                  Positioned(
                    bottom: 50,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withOpacity(0.7)),
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTitle(String text) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [
          Colors.white,
          Color(0xFFE0F2FE),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(bounds),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
          height: 1.1,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSubtitle(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.5,
        color: Colors.white.withOpacity(0.85),
      ),
    );
  }
}
