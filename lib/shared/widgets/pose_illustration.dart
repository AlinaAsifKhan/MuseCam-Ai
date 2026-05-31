import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:muse_cam_ai/core/theme/colors.dart';

enum PoseIllustrationStyle {
  straight,
  profile,
  threeQuarter,
  chinDown,
  dynamic,
  sitting,
}

PoseIllustrationStyle poseIllustrationStyleForId(String poseId) {
  if (poseId.contains('profile')) return PoseIllustrationStyle.profile;
  if (poseId.contains('3_4')) return PoseIllustrationStyle.threeQuarter;
  if (poseId.contains('chin_down')) return PoseIllustrationStyle.chinDown;
  if (poseId.contains('dynamic')) return PoseIllustrationStyle.dynamic;
  if (poseId.contains('sitting')) return PoseIllustrationStyle.sitting;
  return PoseIllustrationStyle.straight;
}

class PoseIllustration extends StatelessWidget {
  final String poseId;
  final bool isSelected;
  final bool dashed;
  final double strokeWidth;

  const PoseIllustration({
    super.key,
    required this.poseId,
    this.isSelected = false,
    this.dashed = false,
    this.strokeWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PoseIllustrationPainter(
        style: poseIllustrationStyleForId(poseId),
        isSelected: isSelected,
        dashed: dashed,
        strokeWidth: strokeWidth,
      ),
    );
  }
}

class PoseIllustrationPainter extends CustomPainter {
  final PoseIllustrationStyle style;
  final bool isSelected;
  final bool dashed;
  final double strokeWidth;

  PoseIllustrationPainter({
    required this.style,
    required this.isSelected,
    required this.dashed,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final color = isSelected ? MuseColors.primary : MuseColors.textSecondary;
    final bodyPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final cx = size.width / 2;
    final headRadius = math.min(size.width, size.height) * 0.09;
    final bodyTop = size.height * 0.28;
    final shoulderY = bodyTop + headRadius * 1.45;
    final hipY = size.height * 0.56;
    final kneeY = size.height * 0.74;
    final footY = size.height * 0.9;

    void line(Offset a, Offset b, [Paint? paint]) {
      final usePaint = paint ?? bodyPaint;
      if (dashed) {
        _drawDashedLine(canvas, a, b, usePaint);
      } else {
        canvas.drawLine(a, b, usePaint);
      }
    }

    void circle(Offset center, double radius, [Paint? paint]) {
      final usePaint = paint ?? bodyPaint;
      if (dashed) {
        _drawDashedCircle(canvas, center: center, radius: radius, paint: usePaint);
      } else {
        canvas.drawCircle(center, radius, usePaint);
      }
    }

    switch (style) {
      case PoseIllustrationStyle.straight:
        circle(Offset(cx, bodyTop + headRadius), headRadius);
        line(Offset(cx, shoulderY), Offset(cx, hipY));
        line(Offset(cx - 0.14 * size.width, shoulderY + 4), Offset(cx + 0.14 * size.width, shoulderY + 4));
        line(Offset(cx, hipY), Offset(cx - 0.11 * size.width, footY));
        line(Offset(cx, hipY), Offset(cx + 0.11 * size.width, footY));
        line(Offset(cx - 0.14 * size.width, shoulderY + 4), Offset(cx - 0.24 * size.width, hipY + 0.05 * size.height));
        line(Offset(cx + 0.14 * size.width, shoulderY + 4), Offset(cx + 0.24 * size.width, hipY + 0.05 * size.height));
        break;
      case PoseIllustrationStyle.profile:
        circle(Offset(cx - size.width * 0.03, bodyTop + headRadius), headRadius * 0.95);
        line(Offset(cx - 0.03 * size.width, shoulderY), Offset(cx - 0.01 * size.width, hipY));
        line(Offset(cx - 0.01 * size.width, shoulderY + 4), Offset(cx + 0.16 * size.width, shoulderY + 0.08 * size.height));
        line(Offset(cx + 0.16 * size.width, shoulderY + 0.08 * size.height), Offset(cx + 0.22 * size.width, shoulderY + 0.24 * size.height));
        line(Offset(cx - 0.01 * size.width, hipY), Offset(cx - 0.11 * size.width, footY));
        line(Offset(cx - 0.01 * size.width, hipY), Offset(cx + 0.08 * size.width, footY));
        break;
      case PoseIllustrationStyle.threeQuarter:
        circle(Offset(cx - size.width * 0.03, bodyTop + headRadius), headRadius);
        line(Offset(cx - 0.03 * size.width, shoulderY), Offset(cx - 0.02 * size.width, hipY));
        line(Offset(cx - 0.02 * size.width, shoulderY + 4), Offset(cx - 0.14 * size.width, shoulderY + 0.08 * size.height));
        line(Offset(cx - 0.14 * size.width, shoulderY + 0.08 * size.height), Offset(cx - 0.22 * size.width, shoulderY + 0.22 * size.height));
        line(Offset(cx - 0.02 * size.width, shoulderY + 4), Offset(cx + 0.16 * size.width, shoulderY + 0.07 * size.height));
        line(Offset(cx + 0.16 * size.width, shoulderY + 0.07 * size.height), Offset(cx + 0.2 * size.width, shoulderY + 0.23 * size.height));
        line(Offset(cx - 0.02 * size.width, hipY), Offset(cx - 0.11 * size.width, footY));
        line(Offset(cx - 0.02 * size.width, hipY), Offset(cx + 0.1 * size.width, footY));
        break;
      case PoseIllustrationStyle.chinDown:
        circle(Offset(cx, bodyTop + headRadius + 2), headRadius * 0.95);
        line(Offset(cx, shoulderY), Offset(cx, hipY));
        line(Offset(cx - 0.14 * size.width, shoulderY + 4), Offset(cx + 0.1 * size.width, shoulderY + 0.02 * size.height));
        line(Offset(cx + 0.1 * size.width, shoulderY + 0.02 * size.height), Offset(cx + 0.14 * size.width, shoulderY + 0.2 * size.height));
        line(Offset(cx, hipY), Offset(cx - 0.08 * size.width, footY));
        line(Offset(cx, hipY), Offset(cx + 0.08 * size.width, footY));
        break;
      case PoseIllustrationStyle.dynamic:
        circle(Offset(cx - 0.02 * size.width, bodyTop + headRadius), headRadius);
        line(Offset(cx - 0.02 * size.width, shoulderY), Offset(cx + 0.03 * size.width, hipY - 0.02 * size.height));
        line(Offset(cx - 0.12 * size.width, shoulderY + 4), Offset(cx - 0.24 * size.width, shoulderY - 0.08 * size.height));
        line(Offset(cx + 0.08 * size.width, shoulderY + 4), Offset(cx + 0.2 * size.width, shoulderY + 0.12 * size.height));
        line(Offset(cx + 0.03 * size.width, hipY - 0.02 * size.height), Offset(cx - 0.14 * size.width, footY));
        line(Offset(cx + 0.03 * size.width, hipY - 0.02 * size.height), Offset(cx + 0.15 * size.width, kneeY));
        line(Offset(cx + 0.15 * size.width, kneeY), Offset(cx + 0.24 * size.width, footY));
        break;
      case PoseIllustrationStyle.sitting:
        circle(Offset(cx, bodyTop + headRadius), headRadius);
        line(Offset(cx, shoulderY), Offset(cx, hipY));
        line(Offset(cx - 0.12 * size.width, shoulderY + 4), Offset(cx + 0.12 * size.width, shoulderY + 4));
        line(Offset(cx, hipY), Offset(cx - 0.14 * size.width, kneeY));
        line(Offset(cx - 0.14 * size.width, kneeY), Offset(cx - 0.08 * size.width, footY));
        line(Offset(cx, hipY), Offset(cx + 0.13 * size.width, kneeY - 0.02 * size.height));
        line(Offset(cx + 0.13 * size.width, kneeY - 0.02 * size.height), Offset(cx + 0.2 * size.width, footY));
        break;
    }
  }

  @override
  bool shouldRepaint(covariant PoseIllustrationPainter oldDelegate) {
    return oldDelegate.style != style ||
        oldDelegate.isSelected != isSelected ||
        oldDelegate.dashed != dashed ||
        oldDelegate.strokeWidth != strokeWidth;
  }

  void _drawDashedLine(
    Canvas canvas,
    Offset start,
    Offset end,
    Paint paint, {
    double dashLength = 10,
    double gapLength = 7,
  }) {
    final totalLength = (end - start).distance;
    if (totalLength == 0) return;

    final direction = (end - start) / totalLength;
    double distance = 0;

    while (distance < totalLength) {
      final segmentStart = start + direction * distance;
      final segmentEnd = start + direction * math.min(distance + dashLength, totalLength);
      canvas.drawLine(segmentStart, segmentEnd, paint);
      distance += dashLength + gapLength;
    }
  }

  void _drawDashedCircle(
    Canvas canvas, {
    required Offset center,
    required double radius,
    required Paint paint,
    double dashLength = 12,
    double gapLength = 7,
  }) {
    final circumference = 2 * math.pi * radius;
    final dashCount = (circumference / (dashLength + gapLength)).ceil();
    if (dashCount == 0) return;

    final stepAngle = (dashLength + gapLength) / radius;
    final dashAngle = dashLength / radius;

    for (var index = 0; index < dashCount; index++) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        index * stepAngle,
        dashAngle,
        false,
        paint,
      );
    }
  }
}