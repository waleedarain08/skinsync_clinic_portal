/// Base exception class for all application exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppException({required this.message, this.code, this.originalError});

  @override
  String toString() => message;
}

/// Exception thrown when there's a network connectivity issue
class NetworkException extends AppException {
  const NetworkException({
    super.message =
        'No internet connection. Please check your network settings.',
    super.code,
    super.originalError,
  });
}

/// Exception thrown when an HTTP request fails
class ApiHttpException extends AppException {
  final int? statusCode;
  final String? responseBody;

  const ApiHttpException({
    required super.message,
    this.statusCode,
    this.responseBody,
    super.code,
    super.originalError,
  });

  /// Creates an ApiHttpException from an HTTP status code
  factory ApiHttpException.fromStatusCode(
    int statusCode, {
    String? responseBody,
  }) {
    String message;
    String? code;

    switch (statusCode) {
      case 400:
        message = 'Bad request. Please check your input.';
        code = 'BAD_REQUEST';
        break;
      case 401:
        message = 'Authentication failed. Please login again.';
        code = 'UNAUTHORIZED';
        break;
      case 403:
        message =
            'Access forbidden. You don\'t have permission to perform this action.';
        code = 'FORBIDDEN';
        break;
      case 404:
        message = 'Resource not found.';
        code = 'NOT_FOUND';
        break;
      case 422:
        message = 'Validation error. Please check your input.';
        code = 'VALIDATION_ERROR';
        break;
      case 429:
        message = 'Too many requests. Please try again later.';
        code = 'RATE_LIMIT_EXCEEDED';
        break;
      case 500:
        message = 'Internal server error. Please try again later.';
        code = 'INTERNAL_SERVER_ERROR';
        break;
      case 502:
        message = 'Bad gateway. The server is temporarily unavailable.';
        code = 'BAD_GATEWAY';
        break;
      case 503:
        message = 'Service unavailable. Please try again later.';
        code = 'SERVICE_UNAVAILABLE';
        break;
      default:
        message = 'An error occurred. Please try again.';
        code = 'HTTP_ERROR';
    }

    return ApiHttpException(
      message: message,
      statusCode: statusCode,
      responseBody: responseBody,
      code: code,
    );
  }
}

/// Exception thrown when a request times out
class TimeoutException extends AppException {
  const TimeoutException({
    super.message =
        'Request timeout. Please check your connection and try again.',
    super.code = 'TIMEOUT',
    super.originalError,
  });
}

/// Exception thrown when there's a format/parsing error
class FormatException extends AppException {
  const FormatException({
    super.message = 'Invalid data format. Please try again.',
    super.code = 'FORMAT_ERROR',
    super.originalError,
  });
}

/// Exception thrown when authentication fails
class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Authentication failed. Please login again.',
    super.code = 'UNAUTHORIZED',
    super.originalError,
  });
}

/// Exception thrown when there's a server error
class ServerException extends AppException {
  const ServerException({
    super.message = 'Server error. Please try again later.',
    super.code = 'SERVER_ERROR',
    super.originalError,
  });
}

/// Exception thrown for unknown/unexpected errors
class UnknownException extends AppException {
  const UnknownException({
    super.message = 'An unexpected error occurred. Please try again.',
    super.code = 'UNKNOWN_ERROR',
    super.originalError,
  });
}
