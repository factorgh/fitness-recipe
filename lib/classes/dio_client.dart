// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  final Dio _dio = Dio();

  DioClient() {
    _dio.options.baseUrl = 'https://fitnessapp.adroit360.com/api/v1';
    _dio.interceptors.add(_AuthInterceptor());
  }

  Dio get dio => _dio;
}

class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    print("--------token from shared preferences: $token");

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    print('--- Request ---');
    print('URL: ${options.uri}');
    print('Method: ${options.method}');
    print('Headers: ${options.headers}');
    print('Data: ${options.data}');
    print('---');

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('--- Response --- ');
    print('Status Code: ${response.statusCode}');
    print('Data: ${response.data}');
    print('---');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('--- Error ---');
    print('Type: ${err.type}');
    print('Message: ${err.message}');
    print('---');
    handler.next(err);
  }
}
