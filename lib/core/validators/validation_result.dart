/// Immutable representation of validation outcome without throwing exceptions.
class ValidationResult {
  const ValidationResult._({
    required this.isValid,
    this.errorMessage,
    this.fieldName,
  });

  /// Successful validation result
  const ValidationResult.valid()
      : isValid = true,
        errorMessage = null,
        fieldName = null;

  /// Failed validation result with descriptive error message
  const ValidationResult.invalid(String errorMessage, {String? fieldName})
      : isValid = false,
        errorMessage = errorMessage,
        fieldName = fieldName;

  final bool isValid;
  final String? errorMessage;
  final String? fieldName;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ValidationResult &&
          runtimeType == other.runtimeType &&
          isValid == other.isValid &&
          errorMessage == other.errorMessage &&
          fieldName == other.fieldName;

  @override
  int get hashCode => Object.hash(isValid, errorMessage, fieldName);

  @override
  String toString() => isValid
      ? 'ValidationResult.valid'
      : 'ValidationResult.invalid(field: $fieldName, error: $errorMessage)';
}
