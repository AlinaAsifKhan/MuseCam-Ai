import 'package:flutter/material.dart';

/// Face landmark - a single point on the face (eye, nose, mouth, etc)
class FaceLandmark {
  /// Landmark type (e.g., 'left_eye', 'nose', 'mouth', etc)
  final String type;

  /// X position in frame (0.0 - frame width)
  final double x;

  /// Y position in frame (0.0 - frame height)
  final double y;

  /// Position as Offset for easy use with Canvas drawing
  Offset get position => Offset(x, y);

  FaceLandmark({
    required this.type,
    required this.x,
    required this.y,
  });

  @override
  String toString() => 'Landmark($type, x:$x, y:$y)';
}
