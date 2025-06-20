import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lockitem_movil/core/error/exceptions.dart';
import 'package:lockitem_movil/data/models/store_model.dart';

abstract class StoreRemoteDataSource {
  Future<List<StoreModel>> getAllStores();
}

const String BASE_URL = 'https://backend-production-41be.up.railway.app/api/v1';

class StoreRemoteDataSourceImpl implements StoreRemoteDataSource {
  final http.Client client;

  StoreRemoteDataSourceImpl({required this.client});

  @override
  Future<List<StoreModel>> getAllStores() async {
    final response = await client.get(
      Uri.parse('$BASE_URL/stores/all'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((storeJson) => StoreModel.fromJson(storeJson)).toList();
    } else {
      final errorBody = json.decode(response.body);
      throw ServerException(errorBody['message'] ?? 'Error al obtener tiendas');
    }
  }
}