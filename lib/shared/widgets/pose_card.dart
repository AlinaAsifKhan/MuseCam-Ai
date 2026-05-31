import 'package:flutter/material.dart';
import '../../features/pose_detection/domain/entities/pose_suggestion.dart';
import 'package:muse_cam_ai/core/theme/colors.dart';
import 'package:muse_cam_ai/core/theme/typography.dart';
import 'package:muse_cam_ai/core/constants/spacing.dart';
import 'pose_illustration.dart';

/// Card widget for a single pose suggestion
class PoseCard extends StatelessWidget {
  /// The pose this card represents
  final PoseSuggestion pose;

  /// Whether this pose is currently selected
  final bool isSelected;

  /// Callback when card is tapped
  final VoidCallback onTap;

  const PoseCard({
    super.key,
    required this.pose,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: MuseSpacing.md),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MuseSpacing.radiusMd),
          border: Border.all(
            color: isSelected
                ? MuseColors.primary
                : MuseColors.textSecondary.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? MuseColors.primary.withValues(alpha: 0.1)
              : MuseColors.surface,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: MuseColors.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Pose preview illustration
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? MuseColors.primary.withValues(alpha: 0.08)
                    : MuseColors.card,
                border: Border.all(
                  color: isSelected
                      ? MuseColors.primary.withValues(alpha: 0.4)
                      : MuseColors.textSecondary.withValues(alpha: 0.08),
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: PoseIllustration(
                poseId: pose.id,
                isSelected: isSelected,
                dashed: false,
                strokeWidth: 1.8,
              ),
            ),

            const SizedBox(height: MuseSpacing.sm),

            // Pose name
            Text(
              pose.name,
              style: MuseTypography.labelMd.copyWith(
                color: isSelected ? MuseColors.primary : MuseColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            // Description
            Text(
              pose.description,
              style: TextStyle(
                fontSize: 10,
                color: MuseColors.textSecondary.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
