import 'package:dio/dio.dart';

import '../utils/contants.dart';

class DioProvider {
  static final Dio dio = _create();

  static Dio provide() {
    return dio;
  }

  static Dio _create() {
    final dio = Dio(BaseOptions(baseUrl: WEATHER_API_URL));
    dio.interceptors.add(LogInterceptor(responseBody: false));
    return dio;
  }
}
