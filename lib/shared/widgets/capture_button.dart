import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:muse_cam_ai/core/theme/colors.dart';
import 'dart:developer' as developer;

/// Animated capture button with ring animation
class CaptureButton extends StatefulWidget {
  /// Callback when capture button is pressed
  final VoidCallback onPressed;

  /// Whether the capture is enabled
  final bool isEnabled;

  /// Quality score for ring fill animation (0-100)
  /// When non-zero, ring fills up gradually
  final double qualityScore;

  /// Size of the button
  final double size;

  const CaptureButton({
    super.key,
    required this.onPressed,
    this.isEnabled = true,
    this.qualityScore = 0,
    this.size = 80,
  });

  @override
  State<CaptureButton> createState() => _CaptureButtonState();
}

class _CaptureButtonState extends State<CaptureButton>
    with TickerProviderStateMixin {
  late AnimationController _tapController;
  late AnimationController _ringController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _ringAnimation;

  @override
  void initState() {
    super.initState();

    // Scale animation on tap (feedback)
    _tapController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _tapController, curve: Curves.easeOut),
    );

    // Ring fill animation for quality feedback
    _ringController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _ringAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ringController, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(CaptureButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Animate ring based on quality score
    if (widget.qualityScore > 0) {
      _ringController.forward(from: widget.qualityScore / 100);
    } else {
      _ringController.reset();
    }
  }

  @override
  void dispose() {
    _tapController.dispose();
    _ringController.dispose();
    super.dispose();
  }

  /// Handle button press with feedback
  Future<void> _handlePress() async {
    if (!widget.isEnabled) return;

    try {
      // Haptic feedback
      await HapticFeedback.heavyImpact();

      // Tap animation
      await _tapController.forward();
      await _tapController.reverse();

      // Call parent callback
      widget.onPressed();
    } catch (e) {
      developer.log('Error in capture button press: $e', error: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTap: _handlePress,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                MuseColors.primary.withOpacity(0.8),
                MuseColors.dustyRose.withOpacity(0.8),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: MuseColors.primary.withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Quality ring (animated fill)
              if (widget.qualityScore > 0)
                AnimatedBuilder(
                  animation: _ringAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size(widget.size, widget.size),
                      painter: QualityRingPainter(
                        progress: _ringAnimation.value,
                        qualityScore: widget.qualityScore / 100,
                      ),
                    );
                  },
                ),

              // Inner white circle (capture point)
              Container(
                width: widget.size * 0.6,
                height: widget.size * 0.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.camera,
                    size: widget.size * 0.3,
                    color: MuseColors.primary,
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

/// Custom painter for quality ring animation
class QualityRingPainter extends CustomPainter {
  final double progress;
  final double qualityScore;

  QualityRingPainter({
    required this.progress,
    required this.qualityScore,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Determine ring color based on quality
    final ringColor = _getQualityColor(qualityScore);

    // Draw background ring (faint)
    final bgPaint = Paint()
      ..color = ringColor.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(center, radius * 0.95, bgPaint);

    // Draw progress ring
    final progressPaint = Paint()
      ..color = ringColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final sweepAngle = (progress * qualityScore) * 2 * 3.14159;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.95),
      -3.14159 / 2, // Start from top
      sweepAngle,
      false,
      progressPaint,
    );

    // Draw quality percentage text at bottom
    if (qualityScore > 0) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${(qualityScore * 100).toStringAsFixed(0)}%',
          style: TextStyle(
            color: ringColor,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          center.dx - textPainter.width / 2,
          center.dy + radius * 0.75,
        ),
      );
    }
  }

  /// Get color based on quality score
  Color _getQualityColor(double quality) {
    if (quality >= 0.8) return const Color(0xFF6FEAB9); // Green
    if (quality >= 0.6) return const Color(0xFFFFD166); // Amber
    return const Color(0xFFFF6B6B); // Red
  }

  @override
  bool shouldRepaint(QualityRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.qualityScore != qualityScore;
  }
}
