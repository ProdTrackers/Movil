import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lockitem_movil/core/error/exceptions.dart';
import 'package:lockitem_movil/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });
}

const String BASE_URL = 'https://backend-production-41be.up.railway.app/api/v1';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('$BASE_URL/user/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = json.decode(response.body);

      if (responseBody.containsKey('id') && responseBody.containsKey('email')) {
        return UserModel.fromJson(responseBody);
      } else {
        throw ServerException('Login exitoso, pero no se recibieron datos del usuario.');
      }

    } else if (response.statusCode == 400 || response.statusCode == 401) {
      final errorBody = json.decode(response.body);
      throw ServerException(errorBody['message'] ?? 'Error de autenticación');
    }
    else {
      throw ServerException('Error del servidor: ${response.statusCode}');
    }
  }

  @override
  Future<UserModel> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final response = await client.post(
      Uri.parse('$BASE_URL/user/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    } else if (response.statusCode == 400) {
      final errorBody = json.decode(response.body);
      throw ServerException(errorBody['message'] ?? 'Error en los datos de registro');
    }
    else {
      throw ServerException('Error del servidor: ${response.statusCode}');
    }
  }
}