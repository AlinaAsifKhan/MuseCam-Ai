import 'package:flutter/material.dart';
import 'package:muse_cam_ai/core/theme/colors.dart';
import 'package:muse_cam_ai/core/theme/typography.dart';
import 'package:muse_cam_ai/core/constants/spacing.dart';

/// HUD (Heads-Up Display) overlay showing capture indicators
/// 
/// Displays real-time feedback for:
/// - Lighting level (brightness)
/// - Clarity (focus/blur detection)
/// - Angle alignment (pose detection)
/// - Overall capture readiness
class HUDOverlay extends StatelessWidget {
  /// Lighting quality (0-100)
  final double lightingQuality;

  /// Clarity/focus quality (0-100)
  final double clarityQuality;

  /// Angle alignment quality (0-100)
  final double angleQuality;

  /// Overall capture readiness (0-100)
  final double overallQuality;

  const HUDOverlay({
    super.key,
    this.lightingQuality = 75,
    this.clarityQuality = 85,
    this.angleQuality = 90,
    this.overallQuality = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MuseSpacing.lg,
        vertical: MuseSpacing.lg,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MuseSpacing.md,
          vertical: MuseSpacing.md,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(MuseSpacing.radiusMd),
          border: Border.all(
            color: MuseColors.warmSand.withOpacity(0.15),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _HUDIndicator(
              label: 'Lighting',
              quality: lightingQuality,
              icon: Icons.wb_sunny_rounded,
            ),
            _VerticalDivider(),
            _HUDIndicator(
              label: 'Clarity',
              quality: clarityQuality,
              icon: Icons.remove_red_eye_rounded,
            ),
            _VerticalDivider(),
            _HUDIndicator(
              label: 'Angle',
              quality: angleQuality,
              icon: Icons.rotate_right_rounded,
            ),
            _VerticalDivider(),
            _HUDIndicator(
              label: 'Overall',
              quality: overallQuality,
              icon: Icons.check_circle_rounded,
            ),
          ],
        ),
      ),
    );
  }
}

/// Vertical divider between indicators
class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: 1,
      color: MuseColors.textSecondary.withOpacity(0.1),
    );
  }
}

/// Individual HUD indicator with improved styling
class _HUDIndicator extends StatelessWidget {
  final String label;
  final double quality;
  final IconData icon;

  const _HUDIndicator({
    required this.label,
    required this.quality,
    required this.icon,
  });

  Color _getQualityColor(double quality) {
    if (quality >= 80) return MuseColors.success;
    if (quality >= 60) return MuseColors.warning;
    return MuseColors.danger;
  }

  String _getQualityLabel(double quality) {
    if (quality >= 80) return 'Good';
    if (quality >= 60) return 'Fair';
    return 'Poor';
  }

  @override
  Widget build(BuildContext context) {
    final color = _getQualityColor(quality);
    final qualityLabel = _getQualityLabel(quality);

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon with quality color
          Icon(
            icon,
            color: color,
            size: 18,
          ),
          SizedBox(height: MuseSpacing.xs),
          
          // Quality percentage text
          Text(
            '${quality.toStringAsFixed(0)}%',
            style: MuseTypography.labelMd.copyWith(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 2),
          
          // Quality label
          Text(
            qualityLabel,
            style: MuseTypography.labelSm.copyWith(
              color: MuseColors.textSecondary.withOpacity(0.7),
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          // Progress bar underneath
          SizedBox(height: MuseSpacing.xs),
          SizedBox(
            width: 32,
            height: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(1.5),
              child: LinearProgressIndicator(
                value: quality / 100,
                backgroundColor: Colors.white.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 3,
              ),
            ),
          ),
          
          // Label
          SizedBox(height: MuseSpacing.sm),
          Text(
            label,
            style: MuseTypography.labelSm.copyWith(
              color: MuseColors.textSecondary,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}
