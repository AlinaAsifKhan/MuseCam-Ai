import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/theme/colors.dart';

/// Animated Gradient Mesh Background
/// Aurora-style animated gradient with slow-moving blobs
class AnimatedGradientMesh extends StatefulWidget {
  final Duration animationDuration;
  final Widget? child;

  const AnimatedGradientMesh({
    Key? key,
    this.animationDuration = const Duration(milliseconds: 8000),
    this.child,
  }) : super(key: key);

  @override
  State<AnimatedGradientMesh> createState() => _AnimatedGradientMeshState();
}

class _AnimatedGradientMeshState extends State<AnimatedGradientMesh>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: SweepGradient(
              center: Alignment(
                0.5 + 0.3 * math.sin(_rotationAnimation.value),
                0.5 + 0.3 * math.cos(_rotationAnimation.value),
              ),
              startAngle: _rotationAnimation.value,
              endAngle: _rotationAnimation.value + 2 * math.pi,
              colors: [
                MuseColors.dark,
                MuseColors.gold.withOpacity(0.15),
                MuseColors.primary.withOpacity(0.15),
                MuseColors.secondary.withOpacity(0.15),
                MuseColors.dark,
              ],
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
