import 'package:flutter/material.dart';
import 'package:muse_cam_ai/features/face_detection/domain/entities/detected_face.dart';

/// Custom painter for drawing face detection overlays
///
/// Draws bounding boxes and confidence percentages for detected faces
class FaceOverlayPainter extends CustomPainter {
  final List<DetectedFace> faces;
  final Color boxColor;
  final Color textColor;
  final double strokeWidth;

  FaceOverlayPainter({
    required this.faces,
    this.boxColor = Colors.green,
    this.textColor = Colors.white,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw each detected face
    for (final face in faces) {
      _drawFaceBox(canvas, face);
      _drawConfidenceText(canvas, face);
      _drawLandmarks(canvas, face);
    }
  }

  /// Draw bounding box for face
  void _drawFaceBox(Canvas canvas, DetectedFace face) {
    final paint = Paint()
      ..color = boxColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawRect(face.boundingBox, paint);
  }

  /// Draw confidence percentage
  void _drawConfidenceText(Canvas canvas, DetectedFace face) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${face.confidencePercent.toStringAsFixed(0)}%',
        style: TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          backgroundColor: boxColor,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // Draw at top-right of bounding box
    final offset = Offset(
      face.boundingBox.right - textPainter.width - 4,
      face.boundingBox.top - textPainter.height - 2,
    );

    textPainter.paint(canvas, offset);
  }

  /// Draw facial landmarks (optional - eyes, nose, mouth)
  void _drawLandmarks(Canvas canvas, DetectedFace face) {
    for (final landmark in face.landmarks) {
      // Draw small circle at each landmark
      canvas.drawCircle(
        landmark.position,
        3,
        Paint()..color = boxColor.withValues(alpha: 0.8),
      );
    }
  }

  @override
  bool shouldRepaint(FaceOverlayPainter oldDelegate) {
    // Repaint if faces changed
    if (oldDelegate.faces.length != faces.length) return true;

    // Check if any face position changed significantly
    for (int i = 0; i < faces.length; i++) {
      if (oldDelegate.faces[i].boundingBox != faces[i].boundingBox) {
        return true;
      }
    }

    return false;
  }
}
