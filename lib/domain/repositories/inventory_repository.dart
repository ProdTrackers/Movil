import 'package:dartz/dartz.dart';
import 'package:lockitem_movil/core/error/failures.dart';
import 'package:lockitem_movil/domain/entities/item_entity.dart';

abstract class InventoryRepository {
  Future<Either<Failure, List<ItemEntity>>> getItemsByStore(String storeId);
}