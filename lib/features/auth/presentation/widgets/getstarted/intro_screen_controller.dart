// controllers/intro_screen_controller.dart
import 'package:flutter/material.dart';
import 'dart:async';

class IntroScreenController extends ChangeNotifier {
  final PageController _pageController = PageController();
  final AnimationController _buttonAnimationController;
  late Animation<double> _buttonAnimation;
  final VoidCallback onNavigateToLogin;

  // Autoplay variables
  Timer? _autoplayTimer;
  static const Duration _autoplayDuration = Duration(seconds: 4);
  bool _isAutoplayActive = true;
  bool _userInteracted = false;
  int _currentPage = 0;

  IntroScreenController({
    required TickerProvider vsync,
    required this.onNavigateToLogin,
  }) : _buttonAnimationController = AnimationController(
          duration: const Duration(milliseconds: 300),
          vsync: vsync,
        ) {
    _initializeAnimations();
    _setupPageController();
    _startAutoplay();
  }

  // Getters
  PageController get pageController => _pageController;
  Animation<double> get buttonAnimation => _buttonAnimation;
  bool get isAutoplayActive => _isAutoplayActive;
  bool get userInteracted => _userInteracted;
  int get currentPage => _currentPage;
  Duration get autoplayDuration => _autoplayDuration;

  void _initializeAnimations() {
    _buttonAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _buttonAnimationController,
      curve: Curves.easeInOut,
    ));
    _buttonAnimationController.forward();
  }

  void _setupPageController() {
    _pageController.addListener(() {
      final newPage = _pageController.page?.round() ?? 0;
      if (newPage != _currentPage) {
        _currentPage = newPage;
        notifyListeners();
      }
    });
  }

  void _startAutoplay() {
    if (!_isAutoplayActive || _userInteracted) return;

    _autoplayTimer?.cancel();
    _autoplayTimer = Timer.periodic(_autoplayDuration, (timer) {
      if (!_isAutoplayActive || _userInteracted) {
        timer.cancel();
        return;
      }

      // You'll need to pass the total pages count or access it differently
      // For now, using a hardcoded value of 3, but this should be parameterized
      const totalPages = 3;
      if (_currentPage < totalPages - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      } else {
        _pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _stopAutoplay() {
    _isAutoplayActive = false;
    _userInteracted = true;
    _autoplayTimer?.cancel();
    notifyListeners();
  }

  void onUserInteraction() {
    _stopAutoplay();
  }

  @override
  void dispose() {
    _autoplayTimer?.cancel();
    _pageController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }
}
