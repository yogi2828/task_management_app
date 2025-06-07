/// lib/features/auth/domain/entities/user.dart
///
/// Defines the User entity for the authentication domain.
/// This entity represents the core properties of a user in our application,
/// independent of how the data is stored or presented.
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String? email;

  const UserEntity({required this.uid, this.email});

  @override
  List<Object?> get props => [uid, email];
}

