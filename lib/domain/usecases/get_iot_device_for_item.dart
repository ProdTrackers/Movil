import 'package:dartz/dartz.dart';
import 'package:lockitem_movil/core/error/failures.dart';
import 'package:lockitem_movil/domain/entities/iot_device_entity.dart';
import 'package:lockitem_movil/domain/repositories/iot_device_repository.dart';

class GetIotDeviceForItem {
  final IotDeviceRepository repository;

  GetIotDeviceForItem(this.repository);

  Future<Either<Failure, IotDeviceEntity?>> call(String inventoryId) async {
    return await repository.getIotDeviceByInventoryId(inventoryId);
  }
}