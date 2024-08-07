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

  AuthRemoteDataSourceImpl() : _dio = DioSingleton().dio;

  @override
  Future<UserModel> signup(
      String email, String password, String fullName, String username) async {
    final response = await _dio.post('/users/signup', data: {
      'email': email,
      'password': password,
      'username': username,
      'fullName': fullName,
    });
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
