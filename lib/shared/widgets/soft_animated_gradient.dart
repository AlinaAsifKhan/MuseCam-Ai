import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/theme/colors.dart';

/// Soft Animated Gradient Background
/// Smooth, flowing gradient with multiple colors - no harsh lines
class SoftAnimatedGradient extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const SoftAnimatedGradient({
    Key? key,
    required this.child,
    this.duration = const Duration(seconds: 15),
  }) : super(key: key);

  @override
  State<SoftAnimatedGradient> createState() => _SoftAnimatedGradientState();
}

class _SoftAnimatedGradientState extends State<SoftAnimatedGradient>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(
                -1 + 2 * math.sin(_controller.value * 2 * math.pi),
                -1 + 2 * math.cos(_controller.value * 2 * math.pi),
              ),
              end: Alignment(
                1 + math.sin(_controller.value * math.pi),
                1 + math.cos(_controller.value * math.pi * 0.7),
              ),
              colors: [
                MuseColors.deepMahogany,
                MuseColors.deepMahogany.withOpacity(0.9),
                Color.lerp(MuseColors.burntOrange, MuseColors.mutedGold,
                    math.sin(_controller.value * math.pi).abs())!,
                Color.lerp(MuseColors.mutedGold, MuseColors.warmSand,
                    math.sin(_controller.value * math.pi * 0.8).abs())!,
                Color.lerp(MuseColors.warmSand, MuseColors.dustyRose,
                    math.cos(_controller.value * math.pi * 0.6).abs())!,
                Color.lerp(MuseColors.dustyRose, MuseColors.mauveRoseTaupe,
                    math.sin(_controller.value * math.pi * 0.5).abs())!,
                MuseColors.mauveRoseTaupe.withOpacity(0.85),
              ],
              stops: const [
                0.0,
                0.12,
                0.25,
                0.4,
                0.55,
                0.75,
                1.0,
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
