import 'package:dartz/dartz.dart';
import 'package:lockitem_movil/core/error/failures.dart';
import 'package:lockitem_movil/domain/repositories/favorite_repository.dart';

class RemoveFavoriteItem {
  final FavoriteRepository repository;
  RemoveFavoriteItem(this.repository);

  Future<Either<Failure, void>> call(String itemId) async {
    return await repository.removeFavoriteItem(itemId);
  }
}