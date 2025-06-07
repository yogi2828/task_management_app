/// lib/core/usecases/usecase.dart
///
/// Defines the base abstract class for all use cases in the domain layer.
/// Use cases encapsulate business logic and orchestrate data flow between
/// repositories and the presentation layer.
import 'package:dartz/dartz.dart'; // Using dartz for Either type. Make sure to add it to pubspec.yaml.
import 'package:equatable/equatable.dart';
import '../errors/failures.dart';

/// Abstract class for a use case that returns a Future<Either<Failure, Type>>
/// and takes parameters.
///
/// [Type] is the return type of the use case.
/// [Params] is the type of parameters required by the use case.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Abstract class for a use case that returns a Stream<Either<Failure, Type>>
/// and takes parameters. Useful for real-time data.
///
/// [Type] is the return type of the use case.
/// [Params] is the type of parameters required by the use case.
abstract class StreamUseCase<Type, Params> {
  Stream<Either<Failure, Type>> call(Params params);
}

/// Class used by use cases that do not require any parameters.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => []; // Ensure this returns List<Object?>
}

/// Class used by use cases that do not return any type.
class NoType extends Equatable {
  const NoType();

  @override
  List<Object?> get props => []; // Ensure this returns List<Object?>
}

