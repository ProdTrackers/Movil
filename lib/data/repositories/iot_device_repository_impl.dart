import 'package:dartz/dartz.dart';
import 'package:lockitem_movil/core/error/exceptions.dart';
import 'package:lockitem_movil/core/error/failures.dart';
import 'package:lockitem_movil/core/platform/network_info.dart';
import 'package:lockitem_movil/data/datasources/remote/iot_device_remote_data_source.dart';
import 'package:lockitem_movil/domain/entities/iot_device_entity.dart';
import 'package:lockitem_movil/domain/repositories/iot_device_repository.dart';

class IotDeviceRepositoryImpl implements IotDeviceRepository {
  final IotDeviceRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  IotDeviceRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, IotDeviceEntity?>> getIotDeviceByInventoryId(String inventoryId) async {
    if (await networkInfo.isConnected) {
      try {
        // 1. Obtener TODOS los dispositivos IoT
        final allRemoteDevices = await remoteDataSource.getAllIotDevices();
        IotDeviceEntity? foundDevice;

        for (final device in allRemoteDevices) {
          if (device.inventoryId.toString() == inventoryId.toString()) {
            foundDevice = device;
            break;
          }
        }

        if (foundDevice != null) {
          print('Found IoT device for inventory ID $inventoryId: ${foundDevice.id}');
          return Right(foundDevice);
        } else {
          print('No IoT device found for inventory ID $inventoryId');
          return Right(null); // Explícitamente devuelve Right(null) si no se encontró
        }
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch(e) { // Si tienes una NetworkException específica
        return Left(NetworkFailure(e.message));
      } catch (e) {
        // Captura genérica para otros errores, como el 'orElse' que lanza si no se maneja
        print('Unexpected error in IotDeviceRepositoryImpl: $e');
        return Left(ServerFailure('Error inesperado al buscar dispositivo IoT: ${e.toString()}'));
      }
    } else {
      return Left(NetworkFailure('No hay conexión a internet.'));
    }
  }
}