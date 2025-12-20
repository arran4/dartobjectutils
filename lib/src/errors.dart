/// Base class for all exceptions in this library.
class DartObjectUtilsException implements Exception {
  final String message;
  DartObjectUtilsException(this.message);
  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when a property could not be retrieved because it is missing
/// or its value is not compatible with the expected type.
class MissingOrInvalidPropertyException extends DartObjectUtilsException {
  MissingOrInvalidPropertyException(super.message);
}

/// Thrown when an element within a collection property is invalid.
class ElementConversionException extends DartObjectUtilsException {
  ElementConversionException(super.message);
}
