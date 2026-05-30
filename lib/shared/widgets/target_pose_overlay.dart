import 'package:flutter/material.dart';
import '../../features/pose_detection/domain/entities/pose_suggestion.dart';
import 'package:muse_cam_ai/core/theme/colors.dart';
import 'package:muse_cam_ai/core/theme/typography.dart';

/// Overlay showing target pose guidance (dashed lines indicating target position)
class TargetPoseOverlay extends StatelessWidget {
  /// The target pose to display
  final PoseSuggestion? targetPose;

  /// Whether to show the overlay
  final bool show;

  const TargetPoseOverlay({
    super.key,
    this.targetPose,
    this.show = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!show || targetPose == null) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: IgnorePointer(
        child: Stack(
          children: [
            // Semi-transparent overlay
            Container(
              color: Colors.black.withOpacity(0.1),
            ),

            // Simple frame overlay (lightweight)
            CustomPaint(
              painter: SimpleFramePainter(poseName: targetPose!.name),
              size: Size.infinite,
            ),

            // Guidance text at bottom
            Positioned(
              bottom: 100,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: MuseColors.dark.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: MuseColors.primary.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Target: ${targetPose!.name}',
                      style: MuseTypography.labelLg.copyWith(
                        color: MuseColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Adjust your position to match the target',
                      style: MuseTypography.bodySm.copyWith(
                        color: MuseColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Simple frame painter (lightweight, no path metrics)
class SimpleFramePainter extends CustomPainter {
  final String poseName;

  SimpleFramePainter({required this.poseName});

  @override
  void paint(Canvas canvas, Size size) {
    const lineWidth = 2.0;
    final framePaint = Paint()
      ..color = MuseColors.primary
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;

    final centerPaint = Paint()
      ..color = MuseColors.primary.withOpacity(0.3)
      ..strokeWidth = 1;

    // Draw simple rectangle border (no dashing for performance)
    final frameRect = Rect.fromLTWH(
      size.width * 0.1,
      size.height * 0.15,
      size.width * 0.8,
      size.height * 0.7,
    );
    canvas.drawRect(frameRect, framePaint);

    // Draw center guidelines
    canvas.drawLine(
      Offset(frameRect.left, frameRect.center.dy),
      Offset(frameRect.right, frameRect.center.dy),
      centerPaint,
    );
    canvas.drawLine(
      Offset(frameRect.center.dx, frameRect.top),
      Offset(frameRect.center.dx, frameRect.bottom),
      centerPaint,
    );

    // Draw corner brackets (simple L shapes)
    const cornerSize = 15.0;
    final cornerPaint = Paint()
      ..color = MuseColors.primary
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    // Top-left
    canvas.drawLine(
      Offset(frameRect.left + cornerSize, frameRect.top),
      Offset(frameRect.left, frameRect.top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(frameRect.left, frameRect.top + cornerSize),
      Offset(frameRect.left, frameRect.top),
      cornerPaint,
    );

    // Top-right
    canvas.drawLine(
      Offset(frameRect.right - cornerSize, frameRect.top),
      Offset(frameRect.right, frameRect.top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(frameRect.right, frameRect.top + cornerSize),
      Offset(frameRect.right, frameRect.top),
      cornerPaint,
    );

    // Bottom-left
    canvas.drawLine(
      Offset(frameRect.left + cornerSize, frameRect.bottom),
      Offset(frameRect.left, frameRect.bottom),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(frameRect.left, frameRect.bottom - cornerSize),
      Offset(frameRect.left, frameRect.bottom),
      cornerPaint,
    );

    // Bottom-right
    canvas.drawLine(
      Offset(frameRect.right - cornerSize, frameRect.bottom),
      Offset(frameRect.right, frameRect.bottom),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(frameRect.right, frameRect.bottom - cornerSize),
      Offset(frameRect.right, frameRect.bottom),
      cornerPaint,
    );

    // Draw pose name in center
    final textPainter = TextPainter(
      text: TextSpan(
        text: poseName,
        style: const TextStyle(
          color: Color(0xFF6FEAB9),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(SimpleFramePainter oldDelegate) {
    return oldDelegate.poseName != poseName;
  }
}
