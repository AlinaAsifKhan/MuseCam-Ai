import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import '../../data/datasources/camera_datasource.dart';
import '../../data/repositories/camera_repository_impl.dart';
import '../../domain/repositories/camera_repository.dart';
import '../../domain/usecases/initialize_camera.dart';
import '../../domain/usecases/get_camera_frame_stream.dart';
import '../../domain/usecases/request_camera_permission.dart';
import '../../domain/usecases/switch_camera_lens.dart';
import '../../domain/entities/camera_frame.dart';
import 'camera_state.dart';
import 'dart:developer' as developer;

/// Provider for camera data source
final cameraDataSourceProvider = Provider((ref) {
  return CameraDataSource();
});

/// Provider for camera repository (dependency injection)
final cameraRepositoryProvider = Provider((ref) {
  final dataSource = ref.watch(cameraDataSourceProvider);
  return CameraRepositoryImpl(dataSource: dataSource);
});

/// Provider for initialize camera use case
final initializeCameraUseCaseProvider = Provider((ref) {
  final repository = ref.watch(cameraRepositoryProvider);
  return InitializeCamera(repository: repository);
});

/// Provider for request permission use case
final requestCameraPermissionUseCaseProvider = Provider((ref) {
  final repository = ref.watch(cameraRepositoryProvider);
  return RequestCameraPermission(repository: repository);
});

/// Provider for get frame stream use case
final getFrameStreamUseCaseProvider = Provider((ref) {
  final repository = ref.watch(cameraRepositoryProvider);
  return GetCameraFrameStream(repository: repository);
});

/// Provider for switch camera lens use case
final switchCameraLensUseCaseProvider = Provider((ref) {
  final repository = ref.watch(cameraRepositoryProvider);
  return SwitchCameraLens(repository: repository);
});

/// StateNotifier for managing camera state
class CameraStateNotifier extends StateNotifier<CameraState> {
  final CameraRepository _repository;

  CameraStateNotifier({required CameraRepository repository})
      : _repository = repository,
        super(CameraState.initial());

  /// Initialize camera
  Future<void> initialize({CameraLensDirection lensDirection = CameraLensDirection.back}) async {
    state = state.copyWith(status: CameraStatus.initializing);

    try {
      // Check permission first
      final hasPermission = await _repository.isCameraPermissionGranted();

      if (!hasPermission) {
        final granted = await _repository.requestCameraPermission();
        if (!granted) {
          state = state.copyWith(
            status: CameraStatus.permissionDenied,
            errorMessage: 'Camera permission denied',
            hasPermission: false,
          );
          return;
        }
      }

      // Initialize camera
      await _repository.initialize(lensDirection: lensDirection);

      state = state.copyWith(
        status: CameraStatus.initialized,
        currentLens: lensDirection,
        hasPermission: true,
        errorMessage: null,
      );

      developer.log('Camera initialized successfully');
    } catch (e) {
      developer.log('Error initializing camera: $e', error: e);
      state = state.copyWith(
        status: CameraStatus.failed,
        errorMessage: 'Failed to initialize camera: $e',
      );
    }
  }

  /// Request camera permission
  Future<bool> requestPermission() async {
    try {
      final granted = await _repository.requestCameraPermission();
      if (granted) {
        state = state.copyWith(hasPermission: true);
      }
      return granted;
    } catch (e) {
      developer.log('Error requesting permission: $e', error: e);
      return false;
    }
  }

  /// Switch camera lens
  Future<void> switchLens(CameraLensDirection lensDirection) async {
    try {
      state = state.copyWith(
        status: CameraStatus.initializing,
        errorMessage: null,
      );
      await _repository.switchCameraLens(lensDirection);
      state = state.copyWith(
        status: CameraStatus.initialized,
        currentLens: lensDirection,
        errorMessage: null,
      );
      developer.log('Switched to lens: $lensDirection');
    } catch (e) {
      developer.log('Error switching lens: $e', error: e);
      state = state.copyWith(
        status: CameraStatus.failed,
        errorMessage: 'Failed to switch camera: $e',
      );
    }
  }

  /// Take picture
  Future<String?> takePicture() async {
    try {
      final path = await _repository.takePicture();
      return path;
    } catch (e) {
      developer.log('Error taking picture: $e', error: e);
      state = state.copyWith(
        errorMessage: 'Failed to take picture: $e',
      );
      return null;
    }
  }

  /// Dispose resources
  @override
  Future<void> dispose() async {
    try {
      await _repository.dispose();
      developer.log('Camera disposed');
    } catch (e) {
      developer.log('Error disposing camera: $e', error: e);
    }
    super.dispose();
  }
}

/// Provider for camera state notifier
final cameraStateProvider = StateNotifierProvider<CameraStateNotifier, CameraState>((ref) {
  final repository = ref.watch(cameraRepositoryProvider);
  return CameraStateNotifier(repository: repository);
});

/// Provider for camera frame stream
final cameraFrameStreamProvider = StreamProvider<CameraFrame>((ref) async* {
  final repository = ref.watch(cameraRepositoryProvider);
  yield* repository.getFrameStream();
});

/// Provider for checking if camera is initialized
final isCameraInitializedProvider = Provider<bool>((ref) {
  final state = ref.watch(cameraStateProvider);
  return state.status == CameraStatus.initialized;
});

/// Provider for current camera lens
final currentCameraLensProvider = Provider<CameraLensDirection>((ref) {
  final state = ref.watch(cameraStateProvider);
  return state.currentLens;
});
