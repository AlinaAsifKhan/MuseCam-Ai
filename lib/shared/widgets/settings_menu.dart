import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:muse_cam_ai/core/theme/colors.dart';
import 'package:muse_cam_ai/core/theme/typography.dart';
import 'package:muse_cam_ai/core/constants/spacing.dart';
import 'package:muse_cam_ai/features/camera/presentation/providers/mode_provider.dart';

/// Settings menu showing mode selection options
class SettingsMenu extends ConsumerWidget {
  const SettingsMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableModes = ref.watch(availableModesProvider);
    final currentMode = ref.watch(modeProvider);

    return Container(
      padding: EdgeInsets.all(MuseSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.85),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(MuseSpacing.radiusLg),
        ),
        border: Border(
          top: BorderSide(
            color: MuseColors.mutedGold.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.only(bottom: MuseSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Capture Mode',
                  style: MuseTypography.displaySm.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: MuseColors.textSecondary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: MuseSpacing.sm),

          // Mode selection cards
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: availableModes.length,
            separatorBuilder: (context, index) =>
                SizedBox(height: MuseSpacing.md),
            itemBuilder: (context, index) {
              final mode = availableModes[index];
              final isSelected = currentMode == mode;

              return GestureDetector(
                onTap: () {
                  ref.read(modeProvider.notifier).selectMode(mode);
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(MuseSpacing.md),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? MuseColors.primary.withValues(alpha: 0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(MuseSpacing.radiusMd),
                    border: Border.all(
                      color: isSelected
                          ? MuseColors.mutedGold.withValues(alpha: 0.6)
                          : MuseColors.textSecondary.withValues(alpha: 0.1),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Mode icon
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? MuseColors.mutedGold.withValues(alpha: 0.2)
                              : MuseColors.textSecondary.withValues(alpha: 0.05),
                          borderRadius:
                              BorderRadius.circular(MuseSpacing.radiusSm),
                        ),
                        child: Center(
                          child: Icon(
                            _getModeIcon(mode),
                            color: isSelected
                                ? MuseColors.mutedGold
                                : MuseColors.textSecondary,
                            size: 24,
                          ),
                        ),
                      ),
                      SizedBox(width: MuseSpacing.md),

                      // Mode details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mode.displayName,
                              style: MuseTypography.labelLg.copyWith(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              mode.description,
                              style: MuseTypography.labelSm.copyWith(
                                color: MuseColors.textSecondary.withValues(alpha: 0.7),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Selection indicator
                      if (isSelected)
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: MuseColors.success,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        )
                      else
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: MuseColors.textSecondary.withValues(alpha: 0.2),
                              width: 1.5,
                            ),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),

          SizedBox(height: MuseSpacing.lg),

          // Info text
          Container(
            padding: EdgeInsets.all(MuseSpacing.md),
            decoration: BoxDecoration(
              color: MuseColors.mutedGold.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(MuseSpacing.radiusSm),
              border: Border.all(
                color: MuseColors.mutedGold.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_rounded,
                  color: MuseColors.mutedGold,
                  size: 16,
                ),
                SizedBox(width: MuseSpacing.sm),
                Expanded(
                  child: Text(
                    'Selected mode will affect camera overlays and guidance',
                    style: MuseTypography.labelSm.copyWith(
                      color: MuseColors.textSecondary.withValues(alpha: 0.8),
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
}
