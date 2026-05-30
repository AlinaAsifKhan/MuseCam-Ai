abstract class Failure {
  final String message;

  Failure({required this.message});
}

/// Camera-related failure
class CameraFailure extends Failure {
  final String? code;

  CameraFailure({
    required super.message,
    this.code,
  });
}

/// Permission-related failure
class PermissionFailure extends Failure {
  final String? code;

  PermissionFailure({
    required super.message,
    this.code,
  });
}

/// Generic operation failure
class OperationFailure extends Failure {
  OperationFailure({required super.message});
}

/// Failure when data is not available
class DataNotFoundFailure extends Failure {
  DataNotFoundFailure({required super.message});
}
