import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/debug/agent_log.dart';
import '../../core/theme/colors.dart';

/// Animated Logo Widget
/// Displays the MuseCam AI logo with floating + glow pulse animation
class AnimatedMuseLogo extends StatefulWidget {
  final double size;
  final bool showGlow;
  final Duration animationDuration;

  const AnimatedMuseLogo({
    Key? key,
    this.size = 120.0,
    this.showGlow = true,
    this.animationDuration = const Duration(milliseconds: 2500),
  }) : super(key: key);

  @override
  State<AnimatedMuseLogo> createState() => _AnimatedMuseLogoState();
}

class _AnimatedMuseLogoState extends State<AnimatedMuseLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _probeLogoAsset();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    )..repeat();

    // Float animation: Y ±8px
    _floatAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Glow animation: opacity 0.3 → 0.7
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // #region agent log
  Future<void> _probeLogoAsset() async {
    const assetPath = 'assets/images/logo.png';
    try {
      final data = await rootBundle.load(assetPath);
      await agentLog(
        location: 'animated_muse_logo.dart:_probeLogoAsset',
        message: 'rootBundle.load succeeded',
        hypothesisId: 'A',
        data: {'assetPath': assetPath, 'byteLength': data.lengthInBytes},
      );
    } catch (e, st) {
      await agentLog(
        location: 'animated_muse_logo.dart:_probeLogoAsset',
        message: 'rootBundle.load failed',
        hypothesisId: 'A',
        data: {
          'assetPath': assetPath,
          'error': e.toString(),
          'stack': st.toString().split('\n').take(3).join(' | '),
        },
      );
    }
  }
  // #endregion

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Glow effect
              if (widget.showGlow)
                Container(
                  width: widget.size + 40,
                  height: widget.size + 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        MuseColors.primary.withOpacity(_glowAnimation.value),
                        MuseColors.primary.withOpacity(0),
                      ],
                    ),
                  ),
                ),
              // Logo
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: MuseColors.primary.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // #region agent log
                      agentLog(
                        location: 'animated_muse_logo.dart:errorBuilder',
                        message: 'Image.asset errorBuilder invoked',
                        hypothesisId: 'B',
                        data: {
                          'assetPath': 'assets/images/logo.png',
                          'error': error.toString(),
                        },
                      );
                      // #endregion
                      return Container(
                        color: MuseColors.surface,
                        child: Icon(
                          Icons.camera_alt_rounded,
                          size: widget.size * 0.6,
                          color: MuseColors.primary,
                        ),
                      );
                    },
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
