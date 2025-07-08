import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakili/common/helpers/app_router.gr.dart';
import 'package:wakili/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:wakili/common/res/colors.dart'; // Import AppColors

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  bool _authCheckCompleted = false;
  bool _animationCompleted = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthBloc>().add(AuthCheckStatus());
    });
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward().then((_) {
      setState(() {
        _animationCompleted = true;
      });
      _tryNavigate();
    });
  }

  void _tryNavigate() {
    if (!mounted) return;

    if (_authCheckCompleted && _animationCompleted) {
      final currentAuthState = context.read<AuthBloc>().state;

      if (currentAuthState is AuthAuthenticated) {
        context.router.replace(const MainRoute());
      } else if (currentAuthState is AuthUnauthenticated) {
        // Redirect to GetStartedRoute for new/logged out users
        context.router.replace(const GetStartedRoute());
      } else if (currentAuthState is AuthError) {
        // For errors, still go to Get Started or Login
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Authentication Error: ${currentAuthState.message}')),
        );
        context.router.replace(const GetStartedRoute()); // Or LoginRoute
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness ==
        Brightness.dark; // Still useful for other elements

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        setState(() {
          _authCheckCompleted = true;
        });
        _tryNavigate();
      },
      child: Scaffold(
        body: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Stack(
              children: [
                // Consistent Split screen background using AppColors (fixed visual halves)
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: AppColors.visualDarkBackgroundHalf,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: AppColors.visualLightBackgroundHalf,
                      ),
                    ),
                  ],
                ),
                // Center vertical divider
                Positioned(
                  left: MediaQuery.of(context).size.width / 2 - 0.5,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 1,
                    color: Colors.grey.withValues(
                        alpha: 0.2), // Using opacity for the divider color
                  ),
                ),
                // Main content
                Center(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Transform.translate(
                      offset: Offset(0, _slideAnimation.value),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Hero(
                            tag: 'app_logo',
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                                // Logo gradient should reflect the fixed visual background halves
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.visualLightBackgroundHalf
                                        .withValues(
                                            alpha: 0.3), // Light side of logo
                                    AppColors.visualDarkBackgroundHalf
                                        .withValues(
                                            alpha: 0.3), // Dark side of logo
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  stops: const [0.5, 0.5],
                                ),
                              ),
                              padding: const EdgeInsets.all(3),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(17),
                                  color: Colors
                                      .white, // Inner color of the logo border
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(17),
                                  child: Image.asset(
                                    'assets/wak.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          // ShaderMask for text to match split background
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [
                                Colors
                                    .white, // Text on the dark side should be white
                                AppColors
                                    .textPrimary, // Text on the light side should be dark
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              stops: const [
                                0.5,
                                0.5
                              ], // Split precisely in the middle
                            ).createShader(bounds),
                            child: Text(
                              'Wakili',
                              style: GoogleFonts.poppins(
                                fontSize: 32,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                                color: Colors
                                    .white, // This color is masked, but a fallback is good practice
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: [
                                Colors
                                    .white70, // Text on the dark side should be light
                                AppColors
                                    .textSecondary, // Text on the light side should be secondary dark
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              stops: const [
                                0.55,
                                0.55
                              ], // Slightly offset for effect
                            ).createShader(bounds),
                            child: Text(
                              'Legal AI Assistant',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.5,
                                color: Colors.white, // This color is masked
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (!_authCheckCompleted)
                  Positioned(
                    bottom: 60,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          // Progress indicator color can still adapt to overall theme
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isDark
                                ? AppColors.textLightDark
                                : AppColors.textLight,
                          ),
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
}
