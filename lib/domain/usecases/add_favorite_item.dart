import 'package:dartz/dartz.dart';
import 'package:lockitem_movil/core/error/failures.dart';
import 'package:lockitem_movil/domain/entities/item_entity.dart';
import 'package:lockitem_movil/domain/repositories/favorite_repository.dart';

class AddFavoriteItem {
  final FavoriteRepository repository;
  AddFavoriteItem(this.repository);

  Future<Either<Failure, void>> call(ItemEntity item) async {
    return await repository.addFavoriteItem(item);
  }
}