import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_cam_ai/core/theme/colors.dart';
import 'package:muse_cam_ai/core/theme/typography.dart';
import 'package:muse_cam_ai/core/constants/spacing.dart';
import 'package:muse_cam_ai/features/camera/presentation/providers/mode_provider.dart';

/// Mode indicator badge showing the current capture mode
/// 
/// Displays the currently selected mode (Portrait, Selfie, Product, Creative)
/// in a subtle badge at the top center of the camera screen.
/// Updates reactively when mode is changed from settings.
class ModeIndicatorBadge extends ConsumerWidget {
  const ModeIndicatorBadge({super.key});

  IconData _getModeIcon(CaptureMode mode) {
    switch (mode) {
      case CaptureMode.portrait:
        return Icons.portrait_rounded;
      case CaptureMode.selfie:
        return Icons.camera_front_rounded;
      case CaptureMode.product:
        return Icons.image_rounded;
      case CaptureMode.creative:
        return Icons.auto_awesome_rounded;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the current mode from the provider
    final currentMode = ref.watch(modeProvider);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MuseSpacing.md,
        vertical: MuseSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.35),
        borderRadius: BorderRadius.circular(MuseSpacing.radiusSm),
        border: Border.all(
          color: MuseColors.mutedGold.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getModeIcon(currentMode),
            color: MuseColors.mutedGold,
            size: 16,
          ),
          SizedBox(width: MuseSpacing.xs),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentMode.displayName,
                style: MuseTypography.labelMd.copyWith(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2),
              Text(
                currentMode.description,
                style: MuseTypography.labelSm.copyWith(
                  color: MuseColors.textSecondary.withOpacity(0.8),
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
