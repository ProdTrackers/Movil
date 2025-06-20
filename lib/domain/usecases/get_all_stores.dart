import 'package:dartz/dartz.dart';
import 'package:lockitem_movil/core/error/failures.dart';
import 'package:lockitem_movil/domain/entities/store_entity.dart';
import 'package:lockitem_movil/domain/repositories/store_repository.dart';

class GetAllStores {
  final StoreRepository repository;

  GetAllStores(this.repository);

  Future<Either<Failure, List<StoreEntity>>> call() async {
    return await repository.getAllStores();
  }
}