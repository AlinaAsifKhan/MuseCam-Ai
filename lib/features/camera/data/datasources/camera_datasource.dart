import 'dart:async';
import 'dart:developer' as developer;
import 'package:camera/camera.dart';
import '../../domain/entities/camera_frame.dart';
import '../models/camera_frame_mapper.dart';

/// Data source for camera operations using camera package
///
/// This wraps the camera package and provides methods to:
/// - Initialize camera
/// - Get frame stream
/// - Handle permissions
/// - Switch cameras
/// - Take photos
class CameraDataSource {
  CameraController? _controller;
  CameraLensDirection _currentLensDirection = CameraLensDirection.back;
  List<CameraDescription> _cameras = [];
  StreamController<CameraFrame>? _frameController;

  /// Initialize cameras (must be called once at app startup)
  Future<void> initializeCameras() async {
    _cameras = await availableCameras();
    developer.log('Found ${_cameras.length} cameras: $_cameras');
  }

  /// Initialize camera with specific lens direction
  Future<void> initializeCamera({
    required CameraLensDirection lensDirection,
  }) async {
    if (_cameras.isEmpty) {
      await initializeCameras();
    }

    // Find camera with matching lens direction
    final camera = _cameras.firstWhere(
      (desc) => desc.lensDirection == lensDirection,
      orElse: () => _cameras.first,
    );

    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false, // Don't enable audio (no microphone)
    );

    try {
      await _controller!.initialize();
      _currentLensDirection = lensDirection;
      developer.log('Camera initialized: $camera');
    } catch (e) {
      developer.log('Error initializing camera: $e', error: e);
      rethrow;
    }
  }

  /// Get frame stream using StreamController
  Stream<CameraFrame> getFrameStream() {
    if (_controller == null) {
      throw Exception('Camera not initialized');
    }

    // Create new stream controller for each subscription
    _frameController = StreamController<CameraFrame>();

    final controller = _controller!;

    // Start image stream
    controller.startImageStream((CameraImage image) {
      try {
        final frame = CameraFrameMapper.fromCameraImage(
          image,
          _currentLensDirection,
        );
        if (_frameController != null && !_frameController!.isClosed) {
          _frameController!.add(frame);
        }
      } catch (e) {
        developer.log('Error processing frame: $e', error: e);
      }
    }).catchError((e) {
      developer.log('Error starting image stream: $e', error: e);
      _frameController?.addError(e);
    });

    // Return the stream
    return _frameController!.stream;
  }

  /// Switch camera lens
  Future<void> switchCameraLens(CameraLensDirection lensDirection) async {
    if (_currentLensDirection == lensDirection) {
      return; // Already on this lens
    }

    // Close current frame controller
    await _frameController?.close();
    _frameController = null;

    // Stop image stream
    try {
      await _controller?.stopImageStream();
    } catch (e) {
      developer.log('Error stopping image stream: $e', error: e);
    }

    // Dispose controller
    await _controller?.dispose();

    // Initialize new camera
    await initializeCamera(lensDirection: lensDirection);
  }

  /// Get current lens direction
  CameraLensDirection getCurrentLensDirection() {
    return _currentLensDirection;
  }

  /// Take a picture
  Future<String> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      throw Exception('Camera not initialized');
    }

    try {
      final image = await _controller!.takePicture();
      return image.path;
    } catch (e) {
      developer.log('Error taking picture: $e', error: e);
      rethrow;
    }
  }

  /// Get camera controller (for preview widget)
  CameraController? getController() => _controller;

  /// Dispose camera resources
  Future<void> dispose() async {
    try {
      await _frameController?.close();
    } catch (e) {
      developer.log('Error closing frame controller: $e', error: e);
    }

    try {
      await _controller?.stopImageStream();
    } catch (e) {
      developer.log('Error stopping image stream: $e', error: e);
    }

    try {
      await _controller?.dispose();
    } catch (e) {
      developer.log('Error disposing controller: $e', error: e);
    }

    _controller = null;
    _frameController = null;
  }
}
