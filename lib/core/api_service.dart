import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<Response> post(String url, Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(url, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> get(String url, {Map<String, dynamic>? params}) async {
    try {
      final response = await _dio.get(url, queryParameters: params);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
