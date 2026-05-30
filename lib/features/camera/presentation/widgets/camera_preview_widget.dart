import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import '../providers/camera_provider.dart';
import '../providers/camera_state.dart';

/// Camera preview widget - displays live camera feed
class CameraPreviewWidget extends ConsumerWidget {
  const CameraPreviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraState = ref.watch(cameraStateProvider);

    if (cameraState.status != CameraStatus.initialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final dataSource = ref.watch(cameraDataSourceProvider);
    final controller = dataSource.getController();

    if (controller == null || !controller.value.isInitialized) {
      return const Center(
        child: Text('Camera not ready'),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: CameraPreview(controller),
    );
  }
}
