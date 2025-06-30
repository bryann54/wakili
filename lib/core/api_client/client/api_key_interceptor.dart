import 'package:dio/dio.dart';

class ApiKeyInterceptor extends Interceptor {
  final String apiKey;

  ApiKeyInterceptor(this.apiKey);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add the API key as a query parameter
    options.queryParameters['api_key'] = apiKey;
    super.onRequest(options, handler);
  }
}
