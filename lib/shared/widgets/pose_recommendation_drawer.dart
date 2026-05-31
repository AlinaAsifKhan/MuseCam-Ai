import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/pose_detection/presentation/providers/pose_recommendation_provider.dart';
import 'package:muse_cam_ai/core/theme/colors.dart';
import 'package:muse_cam_ai/core/theme/typography.dart';
import 'package:muse_cam_ai/core/constants/spacing.dart';
import 'pose_card.dart';

/// Bottom sheet for pose recommendations
class PoseRecommendationDrawer extends ConsumerWidget {
  const PoseRecommendationDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(poseRecommendationProvider);
    final availablePoses = ref.watch(availablePosesProvider);

    return FractionallySizedBox(
      heightFactor: 0.92,
      child: Container(
        decoration: BoxDecoration(
          color: MuseColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(MuseSpacing.radiusLg),
            topRight: Radius.circular(MuseSpacing.radiusLg),
          ),
          boxShadow: [MuseColors.cardShadow],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  MuseSpacing.lg,
                  MuseSpacing.lg,
                  MuseSpacing.lg,
                  MuseSpacing.md,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pose Suggestions',
                      style: MuseTypography.bodyLg.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: MuseSpacing.lg,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Pick a pose and preview its silhouette',
                    style: MuseTypography.bodySm.copyWith(
                      color: MuseColors.textSecondary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: MuseSpacing.md),
              SizedBox(
                height: 168,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: MuseSpacing.lg),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final pose = availablePoses[index];
                    return PoseCard(
                      pose: pose,
                      isSelected: state.selectedPose?.id == pose.id,
                      onTap: () {
                        ref
                            .read(poseRecommendationProvider.notifier)
                            .selectPose(pose);
                      },
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: MuseSpacing.md),
                  itemCount: availablePoses.length,
                ),
              ),
              const SizedBox(height: MuseSpacing.md),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: MuseSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.selectedPose != null) ...[
                        Text(
                          'Guidance',
                          style: MuseTypography.labelLg.copyWith(
                            color: MuseColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: MuseSpacing.sm),
                        ...state.selectedPose!.guidancePoints.map(
                          (point) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: MuseSpacing.sm,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  margin: const EdgeInsets.only(
                                    right: MuseSpacing.md,
                                    top: 6,
                                  ),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: MuseColors.primary,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    point,
                                    style: MuseTypography.bodySm,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ] else
                        Padding(
                          padding: const EdgeInsets.only(top: MuseSpacing.lg),
                          child: Text(
                            'Select a pose to get started',
                            style: MuseTypography.bodySm.copyWith(
                              color: MuseColors.textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  MuseSpacing.lg,
                  MuseSpacing.md,
                  MuseSpacing.lg,
                  MuseSpacing.lg,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: state.selectedPose == null
                        ? null
                        : () {
                            ref
                                .read(poseRecommendationProvider.notifier)
                                .applyPose(state.selectedPose!);
                            Navigator.pop(context);
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: MuseSpacing.md,
                      ),
                      backgroundColor: MuseColors.primary,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          MuseColors.textSecondary.withValues(alpha: 0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(MuseSpacing.radiusMd),
                      ),
                      elevation: 6,
                    ),
                    child: Text(
                      'Apply Pose',
                      style: MuseTypography.labelLg.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
