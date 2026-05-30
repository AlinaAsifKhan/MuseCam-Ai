import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../camera/domain/entities/camera_frame.dart';
import '../../../camera/presentation/providers/camera_provider.dart';
import '../../data/datasources/ml_kit_face_datasource.dart';
import '../../data/repositories/face_detection_repository_impl.dart';
import '../../domain/repositories/face_detection_repository.dart';
import '../../domain/usecases/detect_faces_in_frame.dart';
import '../../domain/entities/detected_face.dart';
import 'face_state.dart';
import 'dart:developer' as developer;

/// Provider for ML Kit data source
final mlKitFaceDataSourceProvider = Provider((ref) {
  return MLKitFaceDataSource();
});

/// Provider for face detection repository
final faceDetectionRepositoryProvider = Provider((ref) {
  final dataSource = ref.watch(mlKitFaceDataSourceProvider);
  return FaceDetectionRepositoryImpl(dataSource: dataSource);
});

/// Provider for detect faces use case
final detectFacesUseCaseProvider = Provider((ref) {
  final repository = ref.watch(faceDetectionRepositoryProvider);
  return DetectFacesInFrame(repository: repository);
});

/// State notifier for face detection
class FaceDetectionNotifier extends StateNotifier<FaceDetectionState> {
  final FaceDetectionRepository _repository;

  FaceDetectionNotifier({required FaceDetectionRepository repository})
      : _repository = repository,
        super(FaceDetectionState());

  /// Process a camera frame for faces
  Future<void> detectFacesInFrame(CameraFrame frame) async {
    // Don't process if already processing
    if (state.isProcessing) {
      return;
    }

    state = state.copyWith(isProcessing: true, error: null);

    try {
      final faces = await _repository.detectFaces(frame);
      state = state.copyWith(
        faces: faces,
        isProcessing: false,
        frameCount: state.frameCount + 1,
      );
      developer.log('Faces detected: ${faces.length}');
    } catch (e) {
      developer.log('Error detecting faces: $e', error: e);
      state = state.copyWith(
        isProcessing: false,
        error: e.toString(),
      );
    }
  }

  /// Dispose resources
  @override
  Future<void> dispose() async {
    try {
      await _repository.dispose();
    } catch (e) {
      developer.log('Error disposing: $e', error: e);
    }
    super.dispose();
  }
}

/// Provider for face detection state notifier
final faceDetectionStateProvider =
    StateNotifierProvider<FaceDetectionNotifier, FaceDetectionState>((ref) {
  final repository = ref.watch(faceDetectionRepositoryProvider);
  return FaceDetectionNotifier(repository: repository);
});

/// Provider that automatically processes frames for face detection
/// Listens to camera frames and triggers detection
final faceDetectionAutoProcessProvider = FutureProvider<void>((ref) async {
  // Watch camera frames
  final cameraFrames = ref.watch(cameraFrameStreamProvider);
  final notifier = ref.read(faceDetectionStateProvider.notifier);

  // Process each frame when it arrives
  cameraFrames.whenData((frame) async {
    await notifier.detectFacesInFrame(frame);
  });
});

/// Convenient provider to get just the detected faces
final detectedFacesProvider = Provider<List<DetectedFace>>((ref) {
  final state = ref.watch(faceDetectionStateProvider);
  return state.faces;
});

/// Provider to check if processing
final isFaceProcessingProvider = Provider<bool>((ref) {
  final state = ref.watch(faceDetectionStateProvider);
  return state.isProcessing;
});

/// Provider for face detection error
final faceDetectionErrorProvider = Provider<String?>((ref) {
  final state = ref.watch(faceDetectionStateProvider);
  return state.error;
});
