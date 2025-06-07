/// lib/core/errors/failures.dart
///
/// Defines custom failure classes for the domain layer.
/// Failures represent business-level problems that occurred.
/// They encapsulate error messages and are returned by repositories
/// using the Either type (from dartz, or a custom implementation).
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final List<Object?> properties; // This should be List<Object?>

  const Failure({required this.message, this.properties = const []});

  @override
  List<Object?> get props => [message, properties]; // Ensure this returns List<Object?>
}

/// Represents a failure that occurred due to a server error.
class ServerFailure extends Failure {
  const ServerFailure({String message = 'Unexpected Server Error'}) : super(message: message);
}

/// Represents a failure that occurred during authentication.
class AuthFailure extends Failure {
  const AuthFailure({String message = 'Authentication Failed'}) : super(message: message);
}

/// Represents a failure that occurred due to network connectivity issues.
class NetworkFailure extends Failure {
  const NetworkFailure({String message = 'No Internet Connection'}) : super(message: message);
}

/// Represents a failure when local data caching fails.
class CacheFailure extends Failure {
  const CacheFailure({String message = 'Failed to cache data'}) : super(message: message);
}

/// Represents a failure due to invalid input data.
class InvalidInputFailure extends Failure {
  const InvalidInputFailure({String message = 'Invalid Input'}) : super(message: message);
}

/// Represents an unknown or unexpected failure.
class UnknownFailure extends Failure {
  const UnknownFailure({String message = 'An unknown error occurred'}) : super(message: message);
}

