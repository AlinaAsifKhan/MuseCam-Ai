import 'package:flutter/material.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import '../../core/constants/spacing.dart';

/// MuseCam AI Gradient Button
/// Primary CTA button with gradient fill and shimmer animation
class MuseGradientButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isFullWidth;
  final double? height;
  final double? borderRadius;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool showShimmer;

  const MuseGradientButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isFullWidth = true,
    this.height = 56.0,
    this.borderRadius = 32.0,
    this.leadingIcon,
    this.trailingIcon,
    this.showShimmer = true,
  }) : super(key: key);

  @override
  State<MuseGradientButton> createState() => _MuseGradientButtonState();
}

class _MuseGradientButtonState extends State<MuseGradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    
    if (widget.showShimmer) {
      _shimmerController = AnimationController(
        duration: const Duration(milliseconds: 1200),
        vsync: this,
      )..forward();

      _shimmerAnimation = Tween<double>(begin: -1, end: 2).animate(
        CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
      );
    }
  }

  @override
  void dispose() {
    if (widget.showShimmer) {
      _shimmerController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() => _isPressed = true);
        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted) setState(() => _isPressed = false);
        });
        widget.onPressed();
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: widget.isFullWidth ? double.infinity : null,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 32),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                MuseColors.mutedGold,
                MuseColors.burntOrange,
                MuseColors.dustyRose,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: MuseColors.burntOrange.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Shimmer overlay (on load)
              if (widget.showShimmer)
                AnimatedBuilder(
                  animation: _shimmerAnimation,
                  builder: (context, child) {
                    return ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          begin: Alignment(-1 - _shimmerAnimation.value, 0),
                          end: Alignment(3 - _shimmerAnimation.value, 0),
                          colors: [
                            Colors.white.withOpacity(0.0),
                            Colors.white.withOpacity(0.3),
                            Colors.white.withOpacity(0.0),
                          ],
                        ).createShader(bounds);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(widget.borderRadius ?? 32),
                        ),
                      ),
                    );
                  },
                ),
              // Button content
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.leadingIcon != null) ...[
                    widget.leadingIcon!,
                    const SizedBox(width: MuseSpacing.md),
                  ],
                  Text(
                    widget.label,
                    style: MuseTypography.labelLg.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (widget.trailingIcon != null) ...[
                    const SizedBox(width: MuseSpacing.md),
                    widget.trailingIcon!,
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
