import 'package:dio/dio.dart';

class ApiFactory {
  static final ApiFactory _singleton = ApiFactory._internal();
  late final Dio _dio;

  factory ApiFactory() {
    return _singleton;
  }

  ApiFactory._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      // connectTimeout: const Duration(seconds: 10),
      // receiveTimeout: const Duration(seconds: 10),
    ));

    // _dio.interceptors.add(LogInterceptor(request: true, responseBody: true));
  }

  Dio get dioInstance => _dio;
}
