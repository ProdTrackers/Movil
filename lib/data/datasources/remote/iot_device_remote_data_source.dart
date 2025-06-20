import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lockitem_movil/core/error/exceptions.dart';
import 'package:lockitem_movil/data/models/iot_device_model.dart';

const String BASE_URL = 'https://backend-production-41be.up.railway.app/api/v1';

abstract class IotDeviceRemoteDataSource {
  Future<List<IotDeviceModel>> getAllIotDevices();
}

class IotDeviceRemoteDataSourceImpl implements IotDeviceRemoteDataSource {
  final http.Client client;

  IotDeviceRemoteDataSourceImpl({required this.client});

  @override
  Future<List<IotDeviceModel>> getAllIotDevices() async {
    final uri = Uri.parse('$BASE_URL/iot-devices');
    print('Fetching ALL IoT devices from: $uri');

    final response = await client.get(uri, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      try {
        return jsonData.map((deviceJson) => IotDeviceModel.fromJson(deviceJson)).toList();
      } catch (e) {
        print('Error parsing IoT devices JSON: $e');
        print('Response body: ${response.body}');
        throw ServerException('Error al parsear la respuesta de dispositivos IoT.');
      }
    } else {
      throw ServerException('Error del servidor al obtener todos los dispositivos IoT: ${response.statusCode}');
    }
  }
}