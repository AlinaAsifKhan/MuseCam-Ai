/// Exception thrown when camera operations fail
class CameraException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;

  CameraException({
    required this.message,
    this.code,
    this.originalException,
  });

  @override
  String toString() => 'CameraException: $message (code: $code)';
}

/// Exception thrown when camera permission is denied or not granted
class PermissionException implements Exception {
  final String message;
  final String? code;

  PermissionException({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'PermissionException: $message (code: $code)';
}

/// Exception thrown for general operation failures
class OperationException implements Exception {
  final String message;
  final dynamic originalException;

  OperationException({
    required this.message,
    this.originalException,
  });

  @override
  String toString() => 'OperationException: $message';
}
