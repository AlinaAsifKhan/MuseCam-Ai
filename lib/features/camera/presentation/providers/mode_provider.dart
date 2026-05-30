import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Available capture modes
enum CaptureMode {
  portrait('Portrait', 'Professional headshot'),
  selfie('Selfie', 'Front-facing self-portrait'),
  product('Product', 'Object photography'),
  creative('Creative', 'Artistic composition');

  final String displayName;
  final String description;

  const CaptureMode(this.displayName, this.description);
}

/// State notifier for managing the current capture mode
class ModeNotifier extends StateNotifier<CaptureMode> {
  ModeNotifier() : super(CaptureMode.portrait);

  void selectMode(CaptureMode mode) {
    state = mode;
  }

  void reset() {
    state = CaptureMode.portrait;
  }
}

/// Provider for the current capture mode
final modeProvider =
    StateNotifierProvider<ModeNotifier, CaptureMode>((ref) {
  return ModeNotifier();
});

/// Provider to get all available modes
final availableModesProvider = Provider<List<CaptureMode>>((ref) {
  return CaptureMode.values;
});
