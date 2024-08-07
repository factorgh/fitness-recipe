import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  late final SharedPreferences prefs;
  Dio dio = Dio(BaseOptions(baseUrl: "http://localhost:3000/api/v1"));

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = prefs.getString('auth_token');

    options.headers.addAll({
      "Content-Type": "application/json",
      "Authorization": "$token",
    });
    // get token from the storage
    if (token != null) {
      options.headers.addAll({
        "Authorization": token,
      });
    }
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }
}
