import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../entities/item_entity.dart';
import '../repositories/inventory_repository.dart';

class GetAllItems {
  final InventoryRepository repository;

  GetAllItems(this.repository);

  Future<Either<Failure, List<ItemEntity>>> call() async {
    return await repository.getAllItems();
  }
}