import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/pose_suggestion.dart';
import 'dart:developer' as developer;

/// State for pose recommendations
class PoseRecommendationState {
  final PoseSuggestion? selectedPose;
  final bool showTargetPose;

  PoseRecommendationState({
    this.selectedPose,
    this.showTargetPose = false,
  });

  PoseRecommendationState copyWith({
    PoseSuggestion? selectedPose,
    bool? showTargetPose,
  }) {
    return PoseRecommendationState(
      selectedPose: selectedPose ?? this.selectedPose,
      showTargetPose: showTargetPose ?? this.showTargetPose,
    );
  }
}

/// Notifier for pose recommendations
class PoseRecommendationNotifier extends StateNotifier<PoseRecommendationState> {
  PoseRecommendationNotifier() : super(PoseRecommendationState());

  /// Select a pose
  void selectPose(PoseSuggestion pose) {
    developer.log('Selected pose: ${pose.name}', name: 'PoseRecommendationNotifier');
    state = state.copyWith(selectedPose: pose);
    state = state.copyWith(showTargetPose: true);
  }

  /// Toggle target pose display
  void toggleTargetPose(bool show) {
    developer.log('Toggle target pose: $show', name: 'PoseRecommendationNotifier');
    state = state.copyWith(showTargetPose: show);
  }

  /// Apply pose (show target overlay)
  void applyPose(PoseSuggestion pose) {
    developer.log('Applying pose: ${pose.name}', name: 'PoseRecommendationNotifier');
    state = state.copyWith(
      selectedPose: pose,
      showTargetPose: true,
    );
  }

  /// Deselect and hide
  void clearPose() {
    developer.log('Clear pose selection', name: 'PoseRecommendationNotifier');
    state = state.copyWith(
      selectedPose: null,
      showTargetPose: false,
    );
  }
}

/// Provider for pose recommendations
final poseRecommendationProvider =
    StateNotifierProvider<PoseRecommendationNotifier, PoseRecommendationState>(
        (ref) {
  return PoseRecommendationNotifier();
});

/// Convenience provider for all available poses
final availablePosesProvider = Provider<List<PoseSuggestion>>((ref) {
  return PoseSuggestions.all;
});

/// Convenience provider for selected pose
final selectedPoseProvider = Provider<PoseSuggestion?>((ref) {
  final state = ref.watch(poseRecommendationProvider);
  return state.selectedPose;
});

/// Convenience provider for target pose visibility
final showTargetPoseProvider = Provider<bool>((ref) {
  final state = ref.watch(poseRecommendationProvider);
  return state.showTargetPose;
});
