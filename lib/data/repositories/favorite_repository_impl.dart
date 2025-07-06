import 'package:dartz/dartz.dart';
import 'package:lockitem_movil/core/error/exceptions.dart';
import 'package:lockitem_movil/core/error/failures.dart';
import 'package:lockitem_movil/data/datasources/local/favorite_local_data_source.dart';
import 'package:lockitem_movil/domain/entities/item_entity.dart';
import 'package:lockitem_movil/domain/repositories/favorite_repository.dart';
import 'package:lockitem_movil/domain/repositories/inventory_repository.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteLocalDataSource localDataSource;
  final InventoryRepository inventoryRepository;

  FavoriteRepositoryImpl({
    required this.localDataSource,
    required this.inventoryRepository,
  });

  @override
  Future<Either<Failure, void>> addFavoriteItem(ItemEntity item) async {
    try {
      await localDataSource.addFavoriteItemId(item.id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('No se pudo añadir a favoritos'));
    }
  }

  @override
  Future<Either<Failure, List<ItemEntity>>> getFavoriteItems() async {
    try {
      final favoriteIds = await localDataSource.getFavoriteItemIds();
      if (favoriteIds.isEmpty) {
        return const Right([]);
      }
      final allItemsEither = await inventoryRepository.getAllItems();

      return allItemsEither.fold(
            (failure) => Left(failure),
            (allItems) {
          final favoriteItems = allItems
              .where((item) => favoriteIds.contains(item.id))
              .toList();
          return Right(favoriteItems);
        },
      );
    } catch (e) {
      return Left(CacheFailure('No se pudieron obtener los favoritos'));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(String itemId) async {
    try {
      final result = await localDataSource.isItemFavorite(itemId);
      return Right(result);
    } catch (e) {
      return Left(CacheFailure('Error al verificar favorito'));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavoriteItem(String itemId) async {
    try {
      await localDataSource.removeFavoriteItemId(itemId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('No se pudo quitar de favoritos'));
    }
  }
}
