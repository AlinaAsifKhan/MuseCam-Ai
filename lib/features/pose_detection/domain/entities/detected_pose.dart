import 'dart:math';
import 'pose_joint.dart';

/// Detected pose entity - pure domain model
/// 
/// This represents a full body pose detected in a camera frame.
/// Contains 33 pose landmarks from MediaPipe Pose model:
/// - Head (5 points)
/// - Shoulders/Arms (8 points)  
/// - Torso (4 points)
/// - Legs (16 points)
class DetectedPose {
  /// List of all pose joints detected
  /// Maximum 33 joints from MediaPipe Pose
  final List<PoseJoint> joints;

  /// Overall pose confidence (average of all joints)
  final double confidence;

  /// Whether this pose represents a full body (not just upper body visible)
  final bool isFullBody;

  /// Center point of pose (around torso)
  /// Calculated from torso joints
  late final (double, double) _center;

  DetectedPose({
    required this.joints,
    required this.confidence,
    required this.isFullBody,
  }) {
    _center = _calculateCenter();
  }

  /// Get pose center (torso region)
  (double, double) get center => _center;

  /// Get all valid joints (above confidence threshold)
  List<PoseJoint> get validJoints => joints.where((j) => j.isValid).toList();

  /// Get confidence as percentage
  double get confidencePercent => confidence * 100;

  /// Calculate center point from torso landmarks
  (double, double) _calculateCenter() {
    // Try to find shoulder/hip landmarks for torso center
    final torsoJoints = joints
        .where((j) =>
            j.type.contains('shoulder') ||
            j.type.contains('hip') ||
            j.type.contains('torso'))
        .toList();

    if (torsoJoints.isEmpty) {
      // Fallback: use all valid joints
      final validJoints = joints.where((j) => j.isValid).toList();
      if (validJoints.isEmpty) return (0, 0);

      final avgX = validJoints.map((j) => j.x).reduce((a, b) => a + b) /
          validJoints.length;
      final avgY = validJoints.map((j) => j.y).reduce((a, b) => a + b) /
          validJoints.length;
      return (avgX, avgY);
    }

    final avgX =
        torsoJoints.map((j) => j.x).reduce((a, b) => a + b) / torsoJoints.length;
    final avgY =
        torsoJoints.map((j) => j.y).reduce((a, b) => a + b) / torsoJoints.length;
    return (avgX, avgY);
  }

  /// Get distance between two joints (in pixels)
  /// Useful for proportional measurements
  double getJointDistance(String joint1Type, String joint2Type) {
    final j1 = joints.firstWhere((j) => j.type == joint1Type,
        orElse: () => PoseJoint(type: 'unknown', x: 0, y: 0, confidence: 0));
    final j2 = joints.firstWhere((j) => j.type == joint2Type,
        orElse: () => PoseJoint(type: 'unknown', x: 0, y: 0, confidence: 0));

    final dx = j1.x - j2.x;
    final dy = j1.y - j2.y;
    return sqrt(dx * dx + dy * dy);
  }

  /// Check if pose is valid for guidance
  bool get isValidForGuidance => validJoints.length > 15 && confidence > 0.3;

  @override
  String toString() =>
      'DetectedPose(${validJoints.length} joints, confidence: $confidence)';
}
