import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../camera/presentation/providers/camera_provider.dart';
import '../../../camera/data/datasources/camera_datasource.dart';
import '../../../../core/services/photo_storage_service.dart';
import 'dart:developer' as developer;
import 'dart:io';

/// Provider for photo storage service
final photoStorageServiceProvider = Provider((ref) {
  return PhotoStorageService;
});

/// State for capture operation
class CaptureState {
  final bool isCapturing;
  final String? lastPhotoPath;
  final String? error;
  final int flashTrigger;

  CaptureState({
    this.isCapturing = false,
    this.lastPhotoPath,
    this.error,
    this.flashTrigger = 0,
  });

  CaptureState copyWith({
    bool? isCapturing,
    String? lastPhotoPath,
    String? error,
    int? flashTrigger,
  }) {
    return CaptureState(
      isCapturing: isCapturing ?? this.isCapturing,
      lastPhotoPath: lastPhotoPath ?? this.lastPhotoPath,
      error: error ?? this.error,
      flashTrigger: flashTrigger ?? this.flashTrigger,
    );
  }
}

/// Notifier for camera capture
class CaptureNotifier extends StateNotifier<CaptureState> {
  final CameraDataSource _cameraDataSource;

  CaptureNotifier({
    required CameraDataSource cameraDataSource,
  })  : _cameraDataSource = cameraDataSource,
        super(CaptureState());

  /// Capture photo and save to device storage
  Future<void> capturePhoto() async {
    if (state.isCapturing) return;

    state = state.copyWith(isCapturing: true, error: null);

    try {
      // Get photo file path from camera
      final filePath = await _cameraDataSource.takePicture();

      if (filePath.isEmpty) {
        throw Exception('Failed to capture photo');
      }

      // Read file bytes
      final file = File(filePath);
      final bytes = await file.readAsBytes();

      // Save to storage using static method
      final savedPath = await PhotoStorageService.savePhoto(bytes);

      if (savedPath != null) {
        developer.log('Photo captured and saved: $savedPath', name: 'CaptureNotifier');
        
        // Trigger flash animation and update state
        state = state.copyWith(
          isCapturing: false,
          lastPhotoPath: savedPath,
          flashTrigger: state.flashTrigger + 1,
        );
      } else {
        throw Exception('Failed to save photo to storage');
      }
    } catch (e) {
      developer.log('Error capturing photo: $e', error: e, name: 'CaptureNotifier');
      state = state.copyWith(
        isCapturing: false,
        error: e.toString(),
      );
    }
  }

  /// Reset flash trigger
  void resetFlash() {
    state = state.copyWith(flashTrigger: 0);
  }
}

/// Provider for camera capture notifier
final captureProvider = StateNotifierProvider<CaptureNotifier, CaptureState>((ref) {
  final cameraDataSource = ref.watch(cameraDataSourceProvider);

  return CaptureNotifier(
    cameraDataSource: cameraDataSource,
  );
});
