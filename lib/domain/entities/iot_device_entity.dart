import 'package:equatable/equatable.dart';

class IotDeviceEntity extends Equatable {
  final String id;
  final double? latitude;
  final double? longitude;
  final String inventoryId;

  const IotDeviceEntity({
    required this.id,
    this.latitude,
    this.longitude,
    required this.inventoryId,
  });

  @override
  List<Object?> get props => [id, latitude, longitude, inventoryId];
}