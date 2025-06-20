import 'package:dartz/dartz.dart';
import 'package:lockitem_movil/core/error/failures.dart';
import 'package:lockitem_movil/domain/entities/user_entity.dart';
import 'package:lockitem_movil/domain/repositories/auth_repository.dart';

class SignupUser {
  final AuthRepository repository;

  SignupUser(this.repository);

  Future<Either<Failure, UserEntity>> call({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    if (firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty) {
      return Left(InvalidInputFailure('Todos los campos son requeridos.'));
    }
    if (password.length < 6) {
      return Left(InvalidInputFailure('La contraseña debe tener al menos 6 caracteres.'));
    }
    if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      return Left(InvalidInputFailure('Formato de email inválido.'));
    }
    return await repository.signup(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );
  }
}