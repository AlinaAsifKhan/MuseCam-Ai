import 'package:flutter/material.dart';
import 'package:muse_cam_ai/core/theme/colors.dart';
import 'package:muse_cam_ai/features/face_detection/domain/entities/detected_face.dart';

/// Bounding box overlay that displays detected faces
/// 
/// Draws animated boxes around detected faces from ML Kit
/// with color feedback based on detection quality
class BoundingBoxOverlay extends StatelessWidget {
  /// List of detected faces
  final List<DetectedFace> detectedFaces;

  /// Screen dimensions for coordinate mapping
  final Size screenSize;

  /// Whether to show confidence labels
  final bool showConfidence;

  /// Animation value (0-1) for pulsing effect
  final double animationValue;

  const BoundingBoxOverlay({
    super.key,
    this.detectedFaces = const [],
    required this.screenSize,
    this.showConfidence = true,
    this.animationValue = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BoundingBoxPainter(
        detectedFaces: detectedFaces,
        screenSize: screenSize,
        showConfidence: showConfidence,
        animationValue: animationValue,
      ),
      size: Size.infinite,
    );
  }
}

/// Custom painter for drawing bounding boxes
class BoundingBoxPainter extends CustomPainter {
  final List<DetectedFace> detectedFaces;
  final Size screenSize;
  final bool showConfidence;
  final double animationValue;

  BoundingBoxPainter({
    required this.detectedFaces,
    required this.screenSize,
    required this.showConfidence,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final face in detectedFaces) {
      _drawFaceBox(canvas, face, size);
    }
  }

  void _drawFaceBox(Canvas canvas, DetectedFace face, Size size) {
    // Determine color based on confidence and angle
    final color = _getBoxColor(face);

    // Create paint for box outline
    final boxPaint = Paint()
      ..color = color
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    // Create paint for corner brackets
    final cornerPaint = Paint()
      ..color = color
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Get bounding box with some padding
    final box = face.boundingBox;
    const padding = 10.0;
    final rect = Rect.fromLTWH(
      box.left - padding,
      box.top - padding,
      box.width + (padding * 2),
      box.height + (padding * 2),
    );

    // Apply pulsing animation effect
    final strokeWidth = 3.0 + (animationValue * 2.0);
    final boxPaintAnimated = boxPaint..strokeWidth = strokeWidth;

    // Draw main bounding box
    canvas.drawRect(rect, boxPaintAnimated);

    // Draw corner brackets (only corners, not full box)
    const cornerSize = 30.0;
    const cornerPadding = 5.0;

    // Top-left
    canvas.drawLine(
      Offset(rect.left - cornerPadding, rect.top + cornerSize),
      Offset(rect.left - cornerPadding, rect.top - cornerPadding),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(rect.left - cornerPadding, rect.top - cornerPadding),
      Offset(rect.left + cornerSize, rect.top - cornerPadding),
      cornerPaint,
    );

    // Top-right
    canvas.drawLine(
      Offset(rect.right + cornerPadding, rect.top - cornerPadding),
      Offset(rect.right + cornerPadding, rect.top + cornerSize),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(rect.right - cornerSize, rect.top - cornerPadding),
      Offset(rect.right + cornerPadding, rect.top - cornerPadding),
      cornerPaint,
    );

    // Bottom-left
    canvas.drawLine(
      Offset(rect.left - cornerPadding, rect.bottom - cornerSize),
      Offset(rect.left - cornerPadding, rect.bottom + cornerPadding),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(rect.left - cornerPadding, rect.bottom + cornerPadding),
      Offset(rect.left + cornerSize, rect.bottom + cornerPadding),
      cornerPaint,
    );

    // Bottom-right
    canvas.drawLine(
      Offset(rect.right + cornerPadding, rect.bottom + cornerPadding),
      Offset(rect.right + cornerPadding, rect.bottom - cornerSize),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(rect.right - cornerSize, rect.bottom + cornerPadding),
      Offset(rect.right + cornerPadding, rect.bottom + cornerPadding),
      cornerPaint,
    );

    // Draw confidence label if enabled
    if (showConfidence) {
      _drawConfidenceLabel(canvas, face, rect);
    }

    // Draw pose quality indicator
    _drawPoseIndicator(canvas, face, rect);
  }

  void _drawConfidenceLabel(Canvas canvas, DetectedFace face, Rect rect) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${(face.confidence * 100).toStringAsFixed(0)}%',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // Background for label
    final labelBgPaint = Paint()
      ..color = Colors.black.withOpacity(0.6);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          rect.left,
          rect.top - 25,
          textPainter.width + 8,
          20,
        ),
        const Radius.circular(4),
      ),
      labelBgPaint,
    );

    // Draw text
    textPainter.paint(
      canvas,
      Offset(rect.left + 4, rect.top - 22),
    );
  }

  void _drawPoseIndicator(Canvas canvas, DetectedFace face, Rect rect) {
    final isLookingAtCamera = face.isLookingAtCamera;
    final indicatorColor =
        isLookingAtCamera ? MuseColors.success : MuseColors.warning;

    final paint = Paint()
      ..color = indicatorColor
      ..style = PaintingStyle.fill;

    // Draw small indicator dot
    canvas.drawCircle(
      Offset(rect.right + 10, rect.top - 10),
      6,
      paint,
    );
  }

  Color _getBoxColor(DetectedFace face) {
    // Green if confident and looking at camera
    if (face.confidence > 0.8 && face.isLookingAtCamera) {
      return MuseColors.success;
    }
    // Amber if moderate confidence
    if (face.confidence > 0.6) {
      return MuseColors.warning;
    }
    // Red if low confidence
    return MuseColors.danger;
  }

  @override
  bool shouldRepaint(BoundingBoxPainter oldDelegate) {
    return detectedFaces != oldDelegate.detectedFaces ||
        animationValue != oldDelegate.animationValue;
  }
}
