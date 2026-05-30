import 'package:camera/camera.dart';
import '../../domain/entities/camera_frame.dart';
import '../../domain/repositories/camera_repository.dart';
import '../datasources/camera_datasource.dart';
import 'package:muse_cam_ai/core/services/permission_service.dart';
import 'dart:developer' as developer;

/// Concrete implementation of CameraRepository
///
/// This implements the abstract interface defined in domain layer.
/// It uses CameraDataSource to interact with the camera package.
class CameraRepositoryImpl implements CameraRepository {
  final CameraDataSource _dataSource;

  CameraRepositoryImpl({required CameraDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<void> initialize({required CameraLensDirection lensDirection}) async {
    try {
      await _dataSource.initializeCamera(lensDirection: lensDirection);
      developer.log('Camera repository initialized');
    } catch (e) {
      developer.log('Failed to initialize camera: $e', error: e);
      rethrow;
    }
  }

  @override
  Future<bool> requestCameraPermission() async {
    try {
      final granted = await PermissionService.requestCameraPermission();
      developer.log('Camera permission: $granted');
      return granted;
    } catch (e) {
      developer.log('Error requesting permission: $e', error: e);
      return false;
    }
  }

  @override
  Future<bool> isCameraPermissionGranted() async {
    try {
      final granted = await PermissionService.isCameraPermissionGranted();
      return granted;
    } catch (e) {
      developer.log('Error checking permission: $e', error: e);
      return false;
    }
  }

  @override
  Stream<CameraFrame> getFrameStream() {
    try {
      return _dataSource.getFrameStream();
    } catch (e) {
      developer.log('Error getting frame stream: $e', error: e);
      rethrow;
    }
  }

  @override
  Future<void> switchCameraLens(CameraLensDirection lensDirection) async {
    try {
      await _dataSource.switchCameraLens(lensDirection);
      developer.log('Switched to lens: $lensDirection');
    } catch (e) {
      developer.log('Failed to switch camera lens: $e', error: e);
      rethrow;
    }
  }

  @override
  CameraLensDirection getCurrentLensDirection() {
    return _dataSource.getCurrentLensDirection();
  }

  @override
  Future<String> takePicture() async {
    try {
      final path = await _dataSource.takePicture();
      developer.log('Picture taken: $path');
      return path;
    } catch (e) {
      developer.log('Failed to take picture: $e', error: e);
      rethrow;
    }
  }

  @override
  Future<void> dispose() async {
    try {
      await _dataSource.dispose();
      developer.log('Camera repository disposed');
    } catch (e) {
      developer.log('Error disposing camera: $e', error: e);
    }
  }
}
