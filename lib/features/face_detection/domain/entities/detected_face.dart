import 'package:flutter/material.dart';
import 'face_landmark.dart';

/// Detected face entity - pure domain model
///
/// This represents a face detected in a camera frame.
/// Contains all information needed for:
/// - Drawing overlays
/// - Determining if capture is ready
/// - Guidance system feedback
class DetectedFace {
  /// Bounding box position and size
  final Rect boundingBox;

  /// Face detection confidence (0.0 - 1.0)
  /// 0.0 = no confidence, 1.0 = very confident
  final double confidence;

  /// List of face landmarks (eyes, nose, mouth, etc)
  final List<FaceLandmark> landmarks;

  /// Head rotation in X axis (pitch) - degrees
  /// Negative = looking down, Positive = looking up
  final double headRotationX;

  /// Head rotation in Y axis (yaw) - degrees
  /// Negative = looking left, Positive = looking right
  final double headRotationY;

  /// Head rotation in Z axis (roll) - degrees
  /// Negative = tilted left, Positive = tilted right
  final double headRotationZ;

  /// Face width/height ratio (aspect ratio)
  /// Used to determine if face is upright
  double get aspectRatio => boundingBox.width / boundingBox.height;

  /// Center point of face
  Offset get center => boundingBox.center;

  /// Get confidence as percentage (0-100)
  double get confidencePercent => confidence * 100;

  /// Check if this is a valid detection
  /// (good confidence, reasonable size)
  bool get isValid => confidence > 0.5;

  /// Check if face is looking roughly straight at camera
  bool get isLookingAtCamera =>
      headRotationX.abs() < 30 && headRotationY.abs() < 30;

  DetectedFace({
    required this.boundingBox,
    required this.confidence,
    required this.landmarks,
    required this.headRotationX,
    required this.headRotationY,
    required this.headRotationZ,
  });

  @override
  String toString() =>
      'DetectedFace(conf:$confidence, box:$boundingBox, rotation:($headRotationX, $headRotationY, $headRotationZ))';
}
