import 'package:wakili/core/api_client/client/api_key_interceptor.dart';
import 'package:wakili/core/api_client/client/loggin_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DioClient {
  final Options open = Options(headers: {'Content-Type': 'application/json'});
  final Dio dio;
  final String _apiKey;

  DioClient(this.dio, @Named('ApiKey') this._apiKey) {
    dio.interceptors.add(DioLogInterceptors(printBody: kDebugMode));
    dio.interceptors.add(ApiKeyInterceptor(_apiKey));
  }

  DioClient getInstance() => this;
}
