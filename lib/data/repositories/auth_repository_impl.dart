import 'package:dartz/dartz.dart';
import 'package:lockitem_movil/core/error/exceptions.dart';
import 'package:lockitem_movil/core/error/failures.dart';
import 'package:lockitem_movil/core/platform/network_info.dart';
import 'package:lockitem_movil/data/datasources/remote/auth_remote_data_source.dart';
import 'package:lockitem_movil/domain/entities/user_entity.dart';
import 'package:lockitem_movil/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> login(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final userModel = await remoteDataSource.login(email, password);
        return Right(userModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Un error inesperado ocurrió: ${e.toString()}'));
      }
    } else {
      return Left(NetworkFailure('No hay conexión a internet.'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final userModel = await remoteDataSource.signup(
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
        );
        return Right(userModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Un error inesperado ocurrió: ${e.toString()}'));
      }
    } else {
      return Left(NetworkFailure('No hay conexión a internet.'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() {
    throw UnimplementedError();
  }
}