import 'package:dartz/dartz.dart';
import 'package:lockitem_movil/core/error/failures.dart';
import 'package:lockitem_movil/domain/entities/item_entity.dart';

abstract class FavoriteRepository {
  Future<Either<Failure, List<ItemEntity>>> getFavoriteItems();
  Future<Either<Failure, void>> addFavoriteItem(ItemEntity item);
  Future<Either<Failure, void>> removeFavoriteItem(String itemId);
  Future<Either<Failure, bool>> isFavorite(String itemId);
// Stream<List<String>> getFavoriteItemIdsStream();
}