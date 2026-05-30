/// A single joint/keypoint in a detected pose
/// 
/// Represents a position in 2D space (or 3D with z inferred from confidence)
/// with an associated body part and confidence level
class PoseJoint {
  /// Name/type of the joint (e.g., 'left_shoulder', 'right_knee')
  final String type;

  /// X coordinate in pixels (0 = left edge)
  final double x;

  /// Y coordinate in pixels (0 = top edge)
  final double y;

  /// Confidence that this joint was detected correctly (0.0 - 1.0)
  final double confidence;

  /// Optional Z coordinate (depth) if available from model
  /// 0.0 = closest, higher values = further away
  final double? z;

  PoseJoint({
    required this.type,
    required this.x,
    required this.y,
    required this.confidence,
    this.z,
  });

  /// Check if this joint detection is valid (high enough confidence)
  bool get isValid => confidence > 0.5;

  @override
  String toString() => 'PoseJoint($type: ($x, $y), confidence: $confidence)';
}
