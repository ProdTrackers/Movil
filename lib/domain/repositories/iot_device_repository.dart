import 'package:dartz/dartz.dart';
import 'package:lockitem_movil/core/error/failures.dart';
import 'package:lockitem_movil/domain/entities/iot_device_entity.dart';

abstract class IotDeviceRepository {
  Future<Either<Failure, IotDeviceEntity?>> getIotDeviceByInventoryId(String inventoryId);
}