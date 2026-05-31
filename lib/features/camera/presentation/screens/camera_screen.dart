import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'dart:developer' as developer;
import '../../../camera/domain/entities/camera_frame.dart';
import '../providers/camera_provider.dart';
import '../providers/camera_state.dart';
import '../providers/capture_provider.dart';
import '../widgets/camera_preview_widget.dart';
import '../widgets/permission_request_widget.dart';
import '../widgets/camera_controls_widget.dart';
import 'package:muse_cam_ai/features/face_detection/presentation/providers/face_detection_provider.dart';
import 'package:muse_cam_ai/features/camera/presentation/providers/mode_provider.dart';
import 'package:muse_cam_ai/features/pose_detection/presentation/providers/pose_recommendation_provider.dart';
import 'package:muse_cam_ai/shared/widgets/grid_guide_overlay.dart';
import 'package:muse_cam_ai/shared/widgets/hud_overlay.dart';
import 'package:muse_cam_ai/shared/widgets/bounding_box_overlay.dart';
import 'package:muse_cam_ai/shared/widgets/capture_button.dart';
import 'package:muse_cam_ai/shared/widgets/capture_flash_overlay.dart';
import 'package:muse_cam_ai/shared/widgets/mode_indicator_badge.dart';
import 'package:muse_cam_ai/shared/widgets/pose_recommendation_button.dart';
import 'package:muse_cam_ai/shared/widgets/target_pose_overlay.dart';

/// Main camera screen
///
/// Handles:
/// - Permission requests
/// - Camera initialization
/// - Live preview display
/// - Controls (switch camera, take picture)
class CameraScreen extends ConsumerStatefulWidget {
  final CaptureMode initialMode;

  const CameraScreen({super.key, required this.initialMode});

  @override
  ConsumerState<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends ConsumerState<CameraScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  StreamSubscription<CameraFrame>? _frameSubscription;

  @override
  void initState() {
    super.initState();
    // Initialize camera when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(cameraStateProvider.notifier);
      ref.read(modeProvider.notifier).selectMode(widget.initialMode);
      notifier.initialize(
        lensDirection: preferredLensForMode(widget.initialMode),
      );
      _startFrameProcessing();
    });

    // Setup pulse animation for bounding box
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  /// Start processing camera frames for face detection
  void _startFrameProcessing() {
    try {
      final dataSource = ref.read(cameraDataSourceProvider);
      final notifier = ref.read(faceDetectionStateProvider.notifier);

      // Subscribe to frame stream and process each frame
      _frameSubscription = dataSource.getFrameStream().listen(
        (frame) {
          // Process frame for face detection
          notifier.detectFacesInFrame(frame);
        },
        onError: (error) {
          developer.log('Frame stream error: $error', error: error);
        },
        cancelOnError: false,
      );
    } catch (e) {
      developer.log('Error starting frame processing: $e', error: e);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _frameSubscription?.cancel();
    // Cleanup
    final notifier = ref.read(cameraStateProvider.notifier);
    notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cameraState = ref.watch(cameraStateProvider);

    ref.listen<CaptureMode>(modeProvider, (previous, next) {
      final currentCameraState = ref.read(cameraStateProvider);
      if (currentCameraState.status != CameraStatus.initialized) {
        return;
      }

      final targetLens = preferredLensForMode(next);
      if (currentCameraState.currentLens != targetLens) {
        ref.read(cameraStateProvider.notifier).switchLens(targetLens);
      }
    });

    return Scaffold(
      body: switch (cameraState.status) {
        CameraStatus.uninitialized ||
        CameraStatus.initializing =>
          const Center(child: CircularProgressIndicator()),
        CameraStatus.permissionDenied =>
          const PermissionRequestWidget(),
        CameraStatus.failed =>
          _ErrorWidget(message: cameraState.errorMessage ?? 'Unknown error'),
        CameraStatus.initialized =>
          _CameraContent(
            cameraState: cameraState,
            pulseAnimation: _pulseController,
          ),
      },
    );
  }
}

/// Camera content when initialized
class _CameraContent extends ConsumerWidget {
  final CameraState cameraState;
  final AnimationController pulseAnimation;

  const _CameraContent({
    required this.cameraState,
    required this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch detected faces
    final detectedFaces = ref.watch(detectedFacesProvider);

    // Watch capture state
    final captureState = ref.watch(captureProvider);

    // Watch pose recommendation state
    final poseState = ref.watch(poseRecommendationProvider);

    // Get screen size
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Full screen camera preview
        Positioned.fill(
          child: CameraPreviewWidget(),
        ),

        // Grid guide overlay
        Positioned.fill(
          child: IgnorePointer(
            child: GridGuideOverlay(opacity: 0.2),
          ),
        ),

        // Bounding box overlay with detected faces
        if (!poseState.showTargetPose)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: pulseAnimation,
                builder: (context, child) {
                  return BoundingBoxOverlay(
                    detectedFaces: detectedFaces,
                    screenSize: screenSize,
                    showConfidence: true,
                    animationValue: pulseAnimation.value,
                  );
                },
              ),
            ),
          ),

        // Mode indicator badge (top center)
        Positioned(
          top: 16,
          left: 0,
          right: 0,
          child: IgnorePointer(
            child: Center(
              child: const ModeIndicatorBadge(),
            ),
          ),
        ),

        // HUD overlay with indicators, moved below the mode badge to avoid overlap
        Positioned(
          top: 72,
          right: 16,
          left: 16,
          child: IgnorePointer(
            child: HUDOverlay(
              lightingQuality: 75,
              clarityQuality: 85,
              angleQuality: 90,
              overallQuality: 80,
            ),
          ),
        ),

        // Flash overlay (white flash on capture)
        Positioned.fill(
          child: CaptureFlashOverlay(flashTrigger: captureState.flashTrigger),
        ),

        // Target pose overlay (dashed silhouette showing target)
        Positioned.fill(
          child: TargetPoseOverlay(
            targetPose: poseState.selectedPose,
            show: poseState.showTargetPose,
          ),
        ),

        // Pose recommendation button (top-right)
        Positioned(
          top: 16,
          right: 16,
          child: const PoseRecommendationButton(),
        ),

        // Capture button (center-bottom)
        Positioned(
          bottom: 100,
          left: 0,
          right: 0,
          child: Center(
            child: CaptureButton(
              onPressed: () {
                final notifier = ref.read(captureProvider.notifier);
                notifier.capturePhoto();
              },
              isEnabled:
                  !captureState.isCapturing && cameraState.status == CameraStatus.initialized,
              qualityScore: 0.8, // Demo quality (can be connected to real detection later)
              size: 80,
            ),
          ),
        ),

        // Camera controls at bottom (flip camera button on left, settings on right)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: CameraControlsWidget(),
        ),
      ],
    );
  }
}

/// Error widget
class _ErrorWidget extends StatelessWidget {
  final String message;

  const _ErrorWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red[400],
            ),
            const SizedBox(height: 24),
            Text(
              'Camera Error',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
