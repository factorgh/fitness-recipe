import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {

    final SharedPreferences prefs;
  Dio dio = Dio(BaseOptions(baseUrl: "https://fitness.adroit360.com"));
  
 


  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = prefs.getString('auth_token');

    options.headers.addAll({
      "Content-Type": "application/json",
      "Authorization": "${token}",
    });
    // get token from the storage
    if (token != null) {
      options.headers.addAll({
        "Authorization": "${token}",
      });
    }
    return super.onRequest(options, handler);
     handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
      return super.onResponse(response);
      handler.next(response);
  }

}
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Check if the user is unauthorized.
    if (err.response?.statusCode == 401) {
      // Refresh the user's authentication token.
      await refreshToken();
      // Retry the request.
      try {
        handler.resolve(await _retry(err.requestOptions));
      } on DioException catch (e) {
        // If the request fails again, pass the error to the next interceptor in the chain.
        handler.next(e);
      }
      // Return to prevent the next interceptor in the chain from being executed.
      return;
    }
    // Pass the error to the next interceptor in the chain.
    handler.next(err);
  }
  