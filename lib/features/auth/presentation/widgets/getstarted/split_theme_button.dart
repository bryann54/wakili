// widgets/split_theme_button.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wakili/common/res/colors.dart';

class SplitThemeButton extends StatefulWidget {
  final Animation<double> animation;
  final VoidCallback onPressed;
  final String? leftText;
  final String? rightText;

  const SplitThemeButton({
    super.key,
    required this.animation,
    required this.onPressed,
    this.leftText = 'GET',
    this.rightText = 'STARTED',
  });

  @override
  State<SplitThemeButton> createState() => _SplitThemeButtonState();
}

class _SplitThemeButtonState extends State<SplitThemeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _hoverAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _hoverAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _handleHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: Listenable.merge([widget.animation, _hoverAnimation]),
      builder: (context, child) {
        final scale =
            widget.animation.value * (1.0 + (_hoverAnimation.value * 0.02));

        return Transform.scale(
            scale: scale,
            child: Center(
              child: Container(
                width: 280, // Reduced width for better proportions
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    // Main drop shadow for depth
                    BoxShadow(
                      color: isDarkMode
                          ? Colors.black.withValues(alpha: 0.6)
                          : Colors.black.withValues(alpha: 0.25),
                      blurRadius: _isHovered ? 28 : 20,
                      offset: Offset(0, _isHovered ? 12 : 8),
                      spreadRadius: _isHovered ? 1 : 0,
                    ),
                    // Secondary shadow for more depth
                    BoxShadow(
                      color: isDarkMode
                          ? Colors.black.withValues(alpha: 0.3)
                          : Colors.black.withValues(alpha: 0.1),
                      blurRadius: _isHovered ? 16 : 12,
                      offset: Offset(0, _isHovered ? 6 : 4),
                      spreadRadius: 0,
                    ),
                    // Inner highlight for raised appearance
                    BoxShadow(
                      color: isDarkMode
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.white.withValues(alpha: 0.8),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                      spreadRadius: -4,
                    ),
                    // Brand glow on hover
                    if (_isHovered)
                      BoxShadow(
                        color: isDarkMode
                            ? AppColors.brandAccent.withValues(alpha: 0.4)
                            : AppColors.brandPrimary.withValues(alpha: 0.3),
                        blurRadius: 40,
                        offset: const Offset(0, 0),
                        spreadRadius: -2,
                      ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    // Subtle border for more definition
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDarkMode
                            ? Colors.white.withValues(alpha: 0.2)
                            : Colors.black.withValues(alpha: 0.1),
                        width: 0.5,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(19.5),
                      child: Stack(
                        children: [
                          // Enhanced split background with gradient overlay
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: isDarkMode
                                          ? [
                                              Colors.white,
                                              Colors.white
                                                  .withValues(alpha: 0.95),
                                            ]
                                          : [
                                              Colors.black,
                                              Colors.black
                                                  .withValues(alpha: 0.95),
                                            ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: isDarkMode
                                          ? [
                                              Colors.black,
                                              Colors.black
                                                  .withValues(alpha: 0.95),
                                            ]
                                          : [
                                              Colors.white,
                                              Colors.white
                                                  .withValues(alpha: 0.95),
                                            ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Hover overlay effect
                          if (_isHovered)
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    (isDarkMode
                                            ? AppColors.brandAccent
                                            : AppColors.brandPrimary)
                                        .withValues(alpha: 0.1),
                                    Colors.transparent,
                                    (isDarkMode
                                            ? AppColors.brandAccent
                                            : AppColors.brandPrimary)
                                        .withValues(alpha: 0.1),
                                  ],
                                ),
                              ),
                            ),
                          _SplitButtonContent(
                            isDarkMode: isDarkMode,
                            onPressed: widget.onPressed,
                            leftText: widget.leftText!,
                            rightText: widget.rightText!,
                            isHovered: _isHovered,
                            onHover: _handleHover,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ));
      },
    );
  }
}

class _SplitButtonContent extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onPressed;
  final String leftText;
  final String rightText;
  final bool isHovered;
  final Function(bool) onHover;

  const _SplitButtonContent({
    required this.isDarkMode,
    required this.onPressed,
    required this.leftText,
    required this.rightText,
    required this.isHovered,
    required this.onHover,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onPressed,
        onHover: onHover,
        splashColor:
            (isDarkMode ? AppColors.brandAccent : AppColors.brandPrimary)
                .withValues(alpha: 0.2),
        highlightColor:
            (isDarkMode ? AppColors.brandAccent : AppColors.brandPrimary)
                .withValues(alpha: 0.1),
        child: SizedBox(
          width: double.infinity,
          height: 64,
          child: Stack(
            children: [
              // Content with enhanced styling
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Left text with enhanced styling
                      Expanded(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: GoogleFonts.poppins(
                            fontSize: isHovered ? 17 : 16,
                            fontWeight: FontWeight.w700,
                            color: isDarkMode ? Colors.black : Colors.white,
                            letterSpacing: isHovered ? 1.4 : 1.2,
                            shadows: isHovered
                                ? [
                                    Shadow(
                                      color: (isDarkMode
                                              ? Colors.black
                                              : Colors.white)
                                          .withValues(alpha: 0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            leftText,
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),

                      // Enhanced divider with animation
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: isHovered ? 2 : 1,
                        height: isHovered ? 32 : 24,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              isDarkMode
                                  ? Colors.grey.withValues(alpha: 0.6)
                                  : Colors.grey.withValues(alpha: 0.4),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),

                      // Right text with enhanced styling
                      Expanded(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: GoogleFonts.poppins(
                            fontSize: isHovered ? 17 : 16,
                            fontWeight: FontWeight.w700,
                            color: isDarkMode ? Colors.white : Colors.black,
                            letterSpacing: isHovered ? 1.4 : 1.2,
                            shadows: isHovered
                                ? [
                                    Shadow(
                                      color: (isDarkMode
                                              ? Colors.white
                                              : Colors.black)
                                          .withValues(alpha: 0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            rightText,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Subtle brand accent border on hover
              if (isHovered)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: (isDarkMode
                                ? AppColors.brandAccent
                                : AppColors.brandPrimary)
                            .withValues(alpha: 0.3),
                        width: 2,
                      ),
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
