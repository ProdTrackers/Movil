import 'package:dartz/dartz.dart';
import 'package:lockitem_movil/core/error/failures.dart';
import 'package:lockitem_movil/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String email, String password);

  Future<Either<Failure, UserEntity>> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> logout();
}