import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/constants/spacing.dart';

/// MuseCam AI Glassmorphism Card
/// Frosted glass effect card with backdrop blur
class MuseGlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double sigmaX;
  final double sigmaY;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final bool addBorder;

  const MuseGlassCard({
    Key? key,
    required this.child,
    this.borderRadius = MuseSpacing.radiusMd,
    this.sigmaX = 16,
    this.sigmaY = 16,
    this.padding = const EdgeInsets.all(MuseSpacing.md),
    this.onTap,
    this.addBorder = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
          child: Container(
            decoration: BoxDecoration(
              color: MuseColors.glass,
              borderRadius: BorderRadius.circular(borderRadius),
              border: addBorder
                  ? Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    )
                  : null,
            ),
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
