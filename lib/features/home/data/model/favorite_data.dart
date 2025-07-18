import 'package:dio/dio.dart';
import '../model/laptop_model.dart';

class FavoriteRepo {
  final Dio dio;
  static const String nationalId = "01009876567876"; // ثابت للاستخدام مع كل الطلبات

  FavoriteRepo(this.dio);

  /// إضافة لابتوب للفيفوريت
  Future<void> addFavorite(String productId) async {
    final response = await dio.post(
      '/favorite',
      data: {
        'nationalId': nationalId,
        'productId': productId,
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Failed to add to favorites");
    }
  }

  /// إزالة لابتوب من الفيفوريت
  Future<void> removeFavorite(String productId) async {
    final response = await dio.delete(
      '/favorite',
      data: {
        'nationalId': nationalId,
        'productId': productId,
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Failed to remove from favorites");
    }
  }

  /// جلب قائمة الفيفوريت من السيرفر
  Future<List<LaptopModel>> getFavorites() async {
    final response = await dio.get(
      '/favorite',
      data: {
        'nationalId': nationalId,
      },
    );

    if (response.statusCode == 200) {
      final List data = response.data['favoriteProducts'];
      return data.map((e) => LaptopModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load favorites");
    }
  }
}
