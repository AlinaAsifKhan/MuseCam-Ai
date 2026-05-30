import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:muse_cam_ai/core/theme/colors.dart';
import 'package:muse_cam_ai/core/constants/spacing.dart';
import 'package:muse_cam_ai/shared/widgets/settings_menu.dart';
import '../providers/camera_provider.dart';

/// Camera controls widget - flip camera button and settings
class CameraControlsWidget extends ConsumerWidget {
  const CameraControlsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLens = ref.watch(currentCameraLensProvider);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MuseSpacing.lg,
        vertical: MuseSpacing.xl,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Flip camera button (left side with gradient styling)
          GestureDetector(
            onTap: () async {
              final notifier = ref.read(cameraStateProvider.notifier);
              final newLens = currentLens == CameraLensDirection.back
                  ? CameraLensDirection.front
                  : CameraLensDirection.back;
              await notifier.switchLens(newLens);
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
                    MuseColors.mutedGold.withOpacity(0.7),
                    MuseColors.burntOrange.withOpacity(0.7),
                  ],
                ),
                border: Border.all(
                  color: MuseColors.warmSand.withOpacity(0.4),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: MuseColors.primary.withOpacity(0.2),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  currentLens == CameraLensDirection.back
                      ? Icons.camera_front
                      : Icons.camera_rear,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),

          /// Spacer
          Spacer(),

          /// Settings/Mode menu button (right side)
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (context) => const SettingsMenu(),
              );
            },
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MuseColors.glass.withOpacity(0.5),
                border: Border.all(
                  color: MuseColors.textSecondary.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.more_vert_rounded,
                  color: MuseColors.textPrimary,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
