// data/datasources/auth_remote_datasource.dart
import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../../../../classes/dio_singleton.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signup(
      String email, String password, String fullName, String username);
  Future<UserModel> login(
    String email,
    String password,
  );
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl() : _dio = DioClient().dio;

  @override
  Future<UserModel> signup(
      String email, String password, String fullName, String username) async {
    final response = await _dio.post('/users/register', data: {
      'email': email,
      'password': password,
      'username': username,
      'fullName': fullName,
    });
    print(
        response.data.result); // For debug purposes, remove before production.
    return UserModel.fromJson(response.data);
  }

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await _dio.post('/users/login', data: {
      'email': email,
      'password': password,
    });
    return UserModel.fromJson(response.data);
  }
}
