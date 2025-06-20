import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lockitem_movil/core/error/exceptions.dart';
import 'package:lockitem_movil/data/models/item_model.dart';

const String BASE_URL = 'https://backend-production-41be.up.railway.app/api/v1';

abstract class InventoryRemoteDataSource {
  Future<List<ItemModel>> getAllInventoryItems();
}

class InventoryRemoteDataSourceImpl implements InventoryRemoteDataSource {
  final http.Client client;

  InventoryRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ItemModel>> getAllInventoryItems() async {
    final uri = Uri.parse('$BASE_URL/inventory');
    print('Fetching ALL items from: $uri');

    final response = await client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((itemJson) => ItemModel.fromJson(itemJson)).toList();
    } else {
      try {
        final errorBody = json.decode(response.body);
        final errorMessage = errorBody['message'] ?? 'Error desconocido del servidor';
        throw ServerException('Error del servidor: ${response.statusCode} - $errorMessage');
      } catch (e) {
        throw ServerException('Error del servidor al obtener el inventario: ${response.statusCode}');
      }
    }
  }
}