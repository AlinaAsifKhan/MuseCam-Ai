import '../../domain/entities/detected_face.dart';

/// Face detection state
class FaceDetectionState {
  final List<DetectedFace> faces;
  final bool isProcessing;
  final String? error;
  final int frameCount;

  FaceDetectionState({
    this.faces = const [],
    this.isProcessing = false,
    this.error,
    this.frameCount = 0,
  });

  FaceDetectionState copyWith({
    List<DetectedFace>? faces,
    bool? isProcessing,
    String? error,
    int? frameCount,
  }) {
    return FaceDetectionState(
      faces: faces ?? this.faces,
      isProcessing: isProcessing ?? this.isProcessing,
      error: error ?? this.error,
      frameCount: frameCount ?? this.frameCount,
    );
  }

  @override
  String toString() =>
      'FaceDetectionState(faces: ${faces.length}, processing: $isProcessing, error: $error)';
}
