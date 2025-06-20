import 'package:lockitem_movil/domain/entities/iot_device_entity.dart';

class IotDeviceModel extends IotDeviceEntity {
  const IotDeviceModel({
    required super.id,
    super.latitude,
    super.longitude,
    required super.inventoryId,
  });

  factory IotDeviceModel.fromJson(Map<String, dynamic> json) {
    double? lat;
    if (json.containsKey('latitude') && json['latitude'] != null) {
      lat = (json['latitude'] as num).toDouble();
    }

    double? lon;
    if (json.containsKey('longitude') && json['longitude'] != null) {
      lon = (json['longitude'] as num).toDouble();
    }

    if (json['id'] == null || json['inventoryId'] == null) {
      throw FormatException("id' o 'inventoryId' no pueden ser nulos en IotDeviceModel.fromJson. Data: $json");
    }

    return IotDeviceModel(
      id: json['id'].toString(),
      latitude: lat,
      longitude: lon,
      inventoryId: json['inventoryId'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'inventoryId': inventoryId,
    };
  }
}