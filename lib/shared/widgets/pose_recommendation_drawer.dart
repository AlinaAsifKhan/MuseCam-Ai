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

    return DraggableScrollableSheet(
      initialChildSize: 0.35,
      minChildSize: 0.25,
      maxChildSize: 0.6,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: MuseColors.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(MuseSpacing.radiusLg),
              topRight: Radius.circular(MuseSpacing.radiusLg),
            ),
            boxShadow: [MuseColors.cardShadow],
          ),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              // Header
              SliverAppBar(
                pinned: true,
                elevation: 0,
                backgroundColor: MuseColors.surface,
                automaticallyImplyLeading: false,
                title: Text(
                  'Pose Suggestions',
                  style: MuseTypography.bodyLg.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                centerTitle: true,
              ),

              // Poses list (horizontal scroll)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: MuseSpacing.lg,
                    vertical: MuseSpacing.md,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: availablePoses
                          .map(
                            (pose) => PoseCard(
                              pose: pose,
                              isSelected: state.selectedPose?.id == pose.id,
                              onTap: () {
                                ref
                                    .read(poseRecommendationProvider.notifier)
                                    .selectPose(pose);
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),

              // Guidance points for selected pose
              if (state.selectedPose != null) ...[
                SliverToBoxAdapter(
                  child: Divider(
                    color: MuseColors.textSecondary.withOpacity(0.2),
                    height: MuseSpacing.lg,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: MuseSpacing.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Guidance',
                          style: MuseTypography.labelLg.copyWith(
                            color: MuseColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: MuseSpacing.sm),
                        ...state.selectedPose!.guidancePoints
                            .map(
                              (point) => Padding(
                                padding: const EdgeInsets.only(
                                  bottom: MuseSpacing.sm,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      margin: const EdgeInsets.only(
                                        right: MuseSpacing.md,
                                        top: 6,
                                      ),
                                      decoration: BoxDecoration(
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
                            )
                            .toList(),
                      ],
                    ),
                  ),
                ),
              ],

              // Apply button
              if (state.selectedPose != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(MuseSpacing.lg),
                    child: GestureDetector(
                      onTap: () {
                        // Apply pose (show target overlay)
                        ref
                            .read(poseRecommendationProvider.notifier)
                            .applyPose(state.selectedPose!);

                        // Close drawer
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: MuseSpacing.md,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              MuseColors.primary,
                              MuseColors.dustyRose,
                            ],
                          ),
                          borderRadius:
                              BorderRadius.circular(MuseSpacing.radiusMd),
                          boxShadow: [
                            BoxShadow(
                              color: MuseColors.primary.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
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
                  ),
                )
              else
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(MuseSpacing.lg),
                    child: Text(
                      'Select a pose to get started',
                      style: MuseTypography.bodySm.copyWith(
                        color: MuseColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
