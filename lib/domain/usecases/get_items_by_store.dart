import 'package:dartz/dartz.dart';
import 'package:lockitem_movil/core/error/failures.dart';
import 'package:lockitem_movil/domain/entities/item_entity.dart';
import 'package:lockitem_movil/domain/repositories/inventory_repository.dart';

class GetItemsByStore {
  final InventoryRepository repository;

  GetItemsByStore(this.repository);

  Future<Either<Failure, List<ItemEntity>>> call(String storeId) async {
    return await repository.getItemsByStore(storeId);
  }
}