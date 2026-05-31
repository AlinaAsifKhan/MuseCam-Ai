import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_cam_ai/core/theme/colors.dart';
import '../../features/pose_detection/presentation/providers/pose_recommendation_provider.dart';
import 'pose_recommendation_drawer.dart';

/// Button to open pose recommendations
class PoseRecommendationButton extends ConsumerWidget {
  const PoseRecommendationButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPose = ref.watch(selectedPoseProvider);

    return GestureDetector(
      onTap: () {
        // Show pose recommendation drawer
        showModalBottomSheet(
          context: context,
          builder: (context) => const PoseRecommendationDrawer(),
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
        );
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              selectedPose != null
                  ? MuseColors.success
                  : MuseColors.primary,
              selectedPose != null
                  ? MuseColors.success.withValues(alpha: 0.7)
                  : MuseColors.dustyRose.withValues(alpha: 0.7),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: (selectedPose != null
                      ? MuseColors.success
                      : MuseColors.primary)
                  .withValues(alpha: 0.4),
              blurRadius: 16,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(
          selectedPose != null ? Icons.check : Icons.auto_awesome,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
