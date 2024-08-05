import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioSingleton {
  static final DioSingleton _singleton = DioSingleton._internal();
  late Dio dio;

  factory DioSingleton() {
    return _singleton;
  }

  DioSingleton._internal() {
    _initializeDio();
  }

  Future<void> _initializeDio() async {
    final prefs = await SharedPreferences.getInstance();
    dio = Dio(BaseOptions(
      baseUrl: 'http://localhost:3000/api/v1',
    ));
    dio.interceptors.add(AuthInterceptor(prefs));
  }
}

class AuthInterceptor extends Interceptor {
  final SharedPreferences prefs;

  AuthInterceptor(this.prefs);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = prefs.getString('auth_token');
    if (token != null) {
      options.headers['Authorization'] = token;
    }
    handler.next(options);
  }
}
