import 'package:flutter/material.dart';

/// Full-screen white flash animation on photo capture
class CaptureFlashOverlay extends StatefulWidget {
  /// Trigger the flash when this value changes
  final int flashTrigger;

  const CaptureFlashOverlay({
    super.key,
    this.flashTrigger = 0,
  });

  @override
  State<CaptureFlashOverlay> createState() => _CaptureFlashOverlayState();
}

class _CaptureFlashOverlayState extends State<CaptureFlashOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flashAnimation;
  int _lastTrigger = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _flashAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void didUpdateWidget(CaptureFlashOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Trigger flash when flashTrigger changes
    if (widget.flashTrigger != _lastTrigger) {
      _lastTrigger = widget.flashTrigger;
      _triggerFlash();
    }
  }

  /// Trigger the flash animation
  Future<void> _triggerFlash() async {
    await _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: FadeTransition(
        opacity: _flashAnimation,
        child: Container(
          color: Colors.white.withOpacity(0.8),
        ),
      ),
    );
  }
}
