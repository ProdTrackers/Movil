import 'package:dartz/dartz.dart';
import 'package:lockitem_movil/core/error/failures.dart';
import 'package:lockitem_movil/domain/repositories/favorite_repository.dart';

class IsItemFavorite {
  final FavoriteRepository repository;
  IsItemFavorite(this.repository);

  Future<Either<Failure, bool>> call(String itemId) async {
    return await repository.isFavorite(itemId);
  }
}