import 'package:dartz/dartz.dart';
import 'package:lockitem_movil/core/error/failures.dart';
import 'package:lockitem_movil/domain/entities/item_entity.dart';
import 'package:lockitem_movil/domain/repositories/favorite_repository.dart';

class GetFavoriteItems {
  final FavoriteRepository repository;
  GetFavoriteItems(this.repository);

  Future<Either<Failure, List<ItemEntity>>> call() async {
    return await repository.getFavoriteItems();
  }
}
