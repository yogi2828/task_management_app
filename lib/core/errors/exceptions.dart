/// lib/core/errors/exceptions.dart
///
/// Defines custom exception classes for the data layer.
/// These exceptions are typically thrown by data sources when
/// an error occurs during data fetching or manipulation.
class ServerException implements Exception {
  final String message;

  const ServerException({this.message = 'Server Error'});

  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {
  final String message;

  const CacheException({this.message = 'Cache Error'});

  @override
  String toString() => 'CacheException: $message';
}

class AuthException implements Exception {
  final String message;

  const AuthException({this.message = 'Authentication Error'});

  @override
  String toString() => 'AuthException: $message';
}

class NetworkException implements Exception {
  final String message;

  const NetworkException({this.message = 'Network Error'});

  @override
  String toString() => 'NetworkException: $message';
}

// Add more specific exceptions as needed, e.g.,
// class InvalidInputException implements Exception {}
// class NotFoundException implements Exception {}

