import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_cam_ai/shared/overlays/face_overlay_painter.dart';
import '../providers/face_detection_provider.dart';

/// Widget that renders face detection overlay on top of camera preview
///
/// Shows:
/// - Green bounding boxes around detected faces
/// - Confidence percentage
/// - Facial landmarks (dots)
class FaceOverlayWidget extends ConsumerWidget {
  const FaceOverlayWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch detected faces
    final faces = ref.watch(detectedFacesProvider);

    return CustomPaint(
      painter: FaceOverlayPainter(faces: faces),
      size: Size.infinite,
    );
  }
}
