/// Generic result wrapper for handling success/failure
/// Used throughout the app for consistent error handling
abstract class AppResult<T> {
  const AppResult();

  /// Map success value or return null
  T? get valueOrNull => this is SuccessResult ? (this as SuccessResult<T>).value : null;
}

/// Success result wrapping data
class SuccessResult<T> extends AppResult<T> {
  final T value;

  const SuccessResult(this.value);

  @override
  String toString() => 'Success($value)';
}

/// Failure result wrapping error
class FailureResult<T> extends AppResult<T> {
  final String message;
  final dynamic error;

  const FailureResult({required this.message, this.error});

  @override
  String toString() => 'Failure($message)';
}
