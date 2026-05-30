/// Suggested pose for the user to match
class PoseSuggestion {
  final String id;
  final String name;
  final String description;
  final String iconPath; // Path to silhouette asset
  final List<String> guidancePoints; // e.g., ["Straighten back", "Relax shoulders"]

  PoseSuggestion({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.guidancePoints,
  });
}

/// Pre-defined suggested poses
class PoseSuggestions {
  static final List<PoseSuggestion> all = [
    PoseSuggestion(
      id: 'portrait_straight',
      name: 'Straight',
      description: 'Face forward, neutral',
      iconPath: 'assets/poses/straight.svg',
      guidancePoints: [
        'Look straight at camera',
        'Relax shoulders',
        'Keep chin level',
      ],
    ),
    PoseSuggestion(
      id: 'portrait_profile',
      name: 'Profile',
      description: 'Side-facing pose',
      iconPath: 'assets/poses/profile.svg',
      guidancePoints: [
        'Turn head to side',
        'Chin slightly forward',
        'Elongate neck',
      ],
    ),
    PoseSuggestion(
      id: 'portrait_3_4',
      name: '3/4 Turn',
      description: 'Three-quarter view',
      iconPath: 'assets/poses/3quarter.svg',
      guidancePoints: [
        'Turn head 45 degrees',
        'Tilt chin down slightly',
        'Relax jaw',
      ],
    ),
    PoseSuggestion(
      id: 'portrait_chin_down',
      name: 'Chin Down',
      description: 'Looking down elegantly',
      iconPath: 'assets/poses/chin_down.svg',
      guidancePoints: [
        'Lower eyes to camera',
        'Tilt chin down',
        'Keep shoulders back',
      ],
    ),
    PoseSuggestion(
      id: 'portrait_dynamic',
      name: 'Dynamic',
      description: 'Movement and energy',
      iconPath: 'assets/poses/dynamic.svg',
      guidancePoints: [
        'Shift weight to one leg',
        'Pop hip',
        'Express energy',
      ],
    ),
    PoseSuggestion(
      id: 'portrait_sitting',
      name: 'Sitting',
      description: 'Seated pose',
      iconPath: 'assets/poses/sitting.svg',
      guidancePoints: [
        'Sit upright',
        'Cross legs or angle',
        'Hand placement intentional',
      ],
    ),
  ];
}
