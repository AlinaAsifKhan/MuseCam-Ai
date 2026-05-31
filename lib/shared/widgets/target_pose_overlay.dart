import 'package:flutter/material.dart';
import '../../features/pose_detection/domain/entities/pose_suggestion.dart';
import 'package:muse_cam_ai/core/theme/colors.dart';
import 'package:muse_cam_ai/core/theme/typography.dart';
import 'pose_illustration.dart';

/// Overlay showing target pose guidance (dashed lines indicating target position)
class TargetPoseOverlay extends StatelessWidget {
  /// The target pose to display
  final PoseSuggestion? targetPose;

  /// Whether to show the overlay
  final bool show;

  const TargetPoseOverlay({
    super.key,
    this.targetPose,
    this.show = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!show || targetPose == null) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: Stack(
        children: [
          // Semi-transparent overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.1),
            ),
          ),

          // Pose silhouette overlay
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: AspectRatio(
                  aspectRatio: 0.75,
                  child: PoseIllustration(
                    poseId: targetPose!.id,
                    isSelected: true,
                    dashed: true,
                    strokeWidth: 2.4,
                  ),
                ),
              ),
            ),
          ),

          // Guidance text at bottom
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: MuseColors.dark.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: MuseColors.primary.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Target: ${targetPose!.name}',
                    style: MuseTypography.labelLg.copyWith(
                      color: MuseColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Match the dashed silhouette guide',
                    style: MuseTypography.bodySm.copyWith(
                      color: MuseColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

