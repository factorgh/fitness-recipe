// data/datasources/auth_remote_datasource.dart
import 'package:dio/dio.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signup(
      String email, String password, String fullName, String username);
  Future<UserModel> login(
    String email,
    String password,
  );
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> signup(
      String email, String password, String fullName, String username) async {
    final response =
        await dio.post('http://localhost:3000/api/v1/users/signup', data: {
      'email': email,
      'password': password,
      'username': username,
      'fullName': fullName,
    });
    return UserModel.fromJson(response.data);
  }

  @override
  Future<UserModel> login(String email, String password) async {
    final response =
        await dio.post('http://localhost:3000/api/v1/users/login', data: {
      'email': email,
      'password': password,
    });
    return UserModel.fromJson(response.data);
  }
}
