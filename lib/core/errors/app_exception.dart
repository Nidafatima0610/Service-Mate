/// Core exception classes for structured error handling
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException(this.message, [this.code, this.details]);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([
    super.message = 'Network connection failed. Please check your internet connection.',
    super.code,
  ]);
}

class ValidationException extends AppException {
  const ValidationException(super.message, [super.code]);
}

class StorageException extends AppException {
  const StorageException([
    super.message = 'Failed to load or save local data.',
  ]);
}

class BookingDuplicateException extends AppException {
  const BookingDuplicateException([
    super.message = 'A booking already exists for this service at the selected date and time.',
  ]);
}

class ResourceNotFoundException extends AppException {
  const ResourceNotFoundException([
    super.message = 'The requested service was not found.',
  ]);
}
