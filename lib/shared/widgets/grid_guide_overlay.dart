import 'package:flutter/material.dart';
import 'package:muse_cam_ai/core/theme/colors.dart';

/// Static grid guide overlay for rule-of-thirds composition
/// 
/// Displays an elegant 3x3 grid with corner accents to help users 
/// compose shots using the rule of thirds.
class GridGuideOverlay extends StatelessWidget {
  /// Opacity of the grid lines (0.0 - 1.0)
  final double opacity;

  const GridGuideOverlay({
    super.key,
    this.opacity = 0.25,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: GridGuidePainter(opacity: opacity),
      size: Size.infinite,
    );
  }
}

/// Custom painter for elegant grid guide with rule of thirds
class GridGuidePainter extends CustomPainter {
  final double opacity;

  GridGuidePainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Main grid lines (thinner, more subtle)
    final gridPaint = Paint()
      ..color = MuseColors.warmSand.withOpacity(opacity * 0.6)
      ..strokeWidth = 0.8;

    // Vertical lines (rule of thirds)
    final verticalLineX1 = width / 3;
    final verticalLineX2 = (width / 3) * 2;

    canvas.drawLine(
      Offset(verticalLineX1, 0),
      Offset(verticalLineX1, height),
      gridPaint,
    );

    canvas.drawLine(
      Offset(verticalLineX2, 0),
      Offset(verticalLineX2, height),
      gridPaint,
    );

    // Horizontal lines (rule of thirds)
    final horizontalLineY1 = height / 3;
    final horizontalLineY2 = (height / 3) * 2;

    canvas.drawLine(
      Offset(0, horizontalLineY1),
      Offset(width, horizontalLineY1),
      gridPaint,
    );

    canvas.drawLine(
      Offset(0, horizontalLineY2),
      Offset(width, horizontalLineY2),
      gridPaint,
    );

    // Corner accent markers (brighter, helps with framing)
    final cornerPaint = Paint()
      ..color = MuseColors.mutedGold.withOpacity(opacity * 1.2)
      ..strokeWidth = 2;

    const cornerSize = 24.0;
    const padding = 8.0;

    // Top-left corner
    canvas.drawLine(
      Offset(padding, padding),
      Offset(padding + cornerSize, padding),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(padding, padding),
      Offset(padding, padding + cornerSize),
      cornerPaint,
    );

    // Top-right corner
    canvas.drawLine(
      Offset(width - padding, padding),
      Offset(width - padding - cornerSize, padding),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(width - padding, padding),
      Offset(width - padding, padding + cornerSize),
      cornerPaint,
    );

    // Bottom-left corner
    canvas.drawLine(
      Offset(padding, height - padding),
      Offset(padding + cornerSize, height - padding),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(padding, height - padding),
      Offset(padding, height - padding - cornerSize),
      cornerPaint,
    );

    // Bottom-right corner
    canvas.drawLine(
      Offset(width - padding, height - padding),
      Offset(width - padding - cornerSize, height - padding),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(width - padding, height - padding),
      Offset(width - padding, height - padding - cornerSize),
      cornerPaint,
    );

    // Intersection dots at rule of thirds points (subtle accent)
    final dotPaint = Paint()
      ..color = MuseColors.mutedGold.withOpacity(opacity * 0.8);

    const dotRadius = 2.5;

    // Vertical intersections with horizontal lines
    for (var x in [verticalLineX1, verticalLineX2]) {
      for (var y in [horizontalLineY1, horizontalLineY2]) {
        canvas.drawCircle(Offset(x, y), dotRadius, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(GridGuidePainter oldDelegate) {
    return opacity != oldDelegate.opacity;
  }
}
