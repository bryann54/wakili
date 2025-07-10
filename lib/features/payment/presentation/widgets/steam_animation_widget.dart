import 'dart:math' as math;
import 'package:flutter/material.dart';

class SteamAnimation extends StatefulWidget {
  final Widget child;
  final double steamHeight;
  final double steamWidth;
  final int steamCount;
  final Duration duration;
  final Color steamColor;
  final double steamOpacity;
  final double steamOffsetRange;

  const SteamAnimation({
    super.key,
    required this.child,
    this.steamHeight = 18.0,
    this.steamWidth = 2.0,
    this.steamCount = 3,
    this.duration = const Duration(seconds: 2),
    this.steamColor = Colors.white,
    this.steamOpacity = 0.7,
    this.steamOffsetRange = 4.0,
  });

  @override
  State<SteamAnimation> createState() => _SteamAnimationState();
}

class _SteamAnimationState extends State<SteamAnimation>
    with TickerProviderStateMixin {
  late AnimationController _steamController;
  late Animation<double> _steamAnimation;

  @override
  void initState() {
    super.initState();

    _steamController = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();

    _steamAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _steamController,
      curve: Curves.easeInOutSine,
    ));
  }

  @override
  void dispose() {
    _steamController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Main child widget (icon)
          widget.child,
          // Steam animations
          ..._buildSteamPuffs(),
        ],
      ),
    );
  }

  List<Widget> _buildSteamPuffs() {
    final List<Widget> steamPuffs = [];

    for (int i = 0; i < widget.steamCount; i++) {
      final double offset =
          (i - (widget.steamCount - 1) / 2) * widget.steamOffsetRange;
      final double delayFactor = i / widget.steamCount;

      steamPuffs.add(_buildSteamPuff(
        offset: offset,
        delayFactor: delayFactor,
      ));
    }

    return steamPuffs;
  }

  Widget _buildSteamPuff({
    required double offset,
    required double delayFactor,
  }) {
    return AnimatedBuilder(
      animation: _steamAnimation,
      builder: (context, child) {
        final double animationValue =
            (_steamAnimation.value + delayFactor) % 1.0;
        final double translateY = -animationValue * widget.steamHeight;
        final double translateX =
            offset * math.sin(animationValue * 2 * math.pi);
        final double opacity =
            (1 - animationValue).clamp(0.0, widget.steamOpacity);
        final double height =
            widget.steamWidth * 3 + (animationValue * widget.steamWidth * 2);

        return Positioned(
          top: 4,
          left: 16 + offset,
          child: Opacity(
            opacity: opacity,
            child: Transform.translate(
              offset: Offset(translateX, translateY),
              child: Container(
                width: widget.steamWidth,
                height: height,
                decoration: BoxDecoration(
                  color:
                      widget.steamColor.withValues(alpha: widget.steamOpacity),
                  borderRadius: BorderRadius.circular(widget.steamWidth / 2),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
