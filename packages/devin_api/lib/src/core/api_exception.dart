/// Exception thrown when an API error occurs
class DevinApiException implements Exception {
  /// Creates a new [DevinApiException]
  const DevinApiException({
    this.statusCode,
    required this.message,
    this.errorCode,
    this.response,
  });

  /// The HTTP status code of the error
  final int? statusCode;

  /// The error message
  final String message;

  /// The error code from the API
  final String? errorCode;

  /// The raw error response from the API
  final Map<String, dynamic>? response;

  @override
  String toString() {
    return 'DevinApiException(statusCode: $statusCode, message: $message, errorCode: $errorCode)';
  }
}
