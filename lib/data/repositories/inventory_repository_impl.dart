import 'package:dartz/dartz.dart';
import 'package:lockitem_movil/core/error/exceptions.dart';
import 'package:lockitem_movil/core/error/failures.dart';
import 'package:lockitem_movil/core/platform/network_info.dart';
import 'package:lockitem_movil/data/datasources/remote/inventory_remote_data_source.dart';
import 'package:lockitem_movil/domain/entities/item_entity.dart';
import 'package:lockitem_movil/domain/repositories/inventory_repository.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  InventoryRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ItemEntity>>> getItemsByStore(String storeId) async {
    if (await networkInfo.isConnected) {
      try {
        final allRemoteItems = await remoteDataSource.getAllInventoryItems();
        final filteredItems = allRemoteItems.where((item) {
          return item.storeId.toString() == storeId.toString();
        }).toList();

        print('Total items fetched: ${allRemoteItems.length}, Filtered items for store $storeId: ${filteredItems.length}');
        return Right(filteredItems);

      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        print('Unexpected error in InventoryRepositoryImpl: $e');
        return Left(ServerFailure('Un error inesperado ocurrió al obtener artículos: ${e.toString()}'));
      }
    } else {
      return Left(NetworkFailure('No hay conexión a internet.'));
    }
  }

  @override
  Future<Either<Failure, List<ItemEntity>>> getAllItems() async {
    if (await networkInfo.isConnected) {
      try {
        final allRemoteItems = await remoteDataSource.getAllInventoryItems();
        print('Total items fetched for global search: ${allRemoteItems.length}');
        return Right(allRemoteItems);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message ?? 'Error de red al obtener todos los artículos.'));
      } catch (e) {
        print('Unexpected error in InventoryRepositoryImpl.getAllItems: $e');
        return Left(ServerFailure('Un error inesperado ocurrió al obtener todos los artículos: ${e.toString()}'));
      }
    } else {
      return Left(NetworkFailure('No hay conexión a internet.'));
    }
  }
}