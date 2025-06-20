import 'package:dartz/dartz.dart';
import 'package:lockitem_movil/core/error/failures.dart';
import 'package:lockitem_movil/domain/entities/user_entity.dart';
import 'package:lockitem_movil/domain/repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository repository;

  LoginUser(this.repository);

  Future<Either<Failure, UserEntity>> call(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return Left(InvalidInputFailure('Email y contraseña no pueden estar vacíos.'));
    }
    if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      return Left(InvalidInputFailure('Formato de email inválido.'));
    }
    return await repository.login(email, password);
  }
}