import 'package:dio/dio.dart';

class DioHelper {
  static Dio createDio() {
    return Dio(BaseOptions(
      baseUrl: 'https://elwekala.onrender.com',
      receiveDataWhenStatusError: true,
    ));
  }
}
