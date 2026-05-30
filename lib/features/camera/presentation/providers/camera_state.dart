import 'package:camera/camera.dart';

/// Camera status enum
enum CameraStatus { uninitialized, initializing, initialized, failed, permissionDenied }

/// Camera state class - holds all camera-related state
class CameraState {
  final CameraStatus status;
  final String? errorMessage;
  final CameraLensDirection currentLens;
  final bool hasPermission;

  CameraState({
    required this.status,
    this.errorMessage,
    required this.currentLens,
    required this.hasPermission,
  });

  /// Create initial state
  factory CameraState.initial() {
    return CameraState(
      status: CameraStatus.uninitialized,
      errorMessage: null,
      currentLens: CameraLensDirection.back,
      hasPermission: false,
    );
  }

  /// Copy with changes
  CameraState copyWith({
    CameraStatus? status,
    String? errorMessage,
    CameraLensDirection? currentLens,
    bool? hasPermission,
  }) {
    return CameraState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      currentLens: currentLens ?? this.currentLens,
      hasPermission: hasPermission ?? this.hasPermission,
    );
  }

  @override
  String toString() =>
      'CameraState(status: $status, lens: $currentLens, hasPermission: $hasPermission)';
}
