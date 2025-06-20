import 'package:dartz/dartz.dart';
import 'package:lockitem_movil/core/error/exceptions.dart';
import 'package:lockitem_movil/core/error/failures.dart';
import 'package:lockitem_movil/core/platform/network_info.dart';
import 'package:lockitem_movil/data/datasources/remote/store_remote_data_source.dart';
import 'package:lockitem_movil/domain/entities/store_entity.dart';
import 'package:lockitem_movil/domain/repositories/store_repository.dart';

class StoreRepositoryImpl implements StoreRepository {
  final StoreRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  StoreRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<StoreEntity>>> getAllStores() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteStores = await remoteDataSource.getAllStores();
        return Right(remoteStores);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Un error inesperado ocurrió al obtener tiendas: ${e.toString()}'));
      }
    } else {
      return Left(NetworkFailure('No hay conexión a internet.'));
    }
  }
}