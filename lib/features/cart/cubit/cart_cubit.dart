import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartModel {
  final String id;
  final String name;
  final String image;
  final List<String> images;
  final String description;
  final String status;
  final String category;
  final String company;
  final double price;
  final int countInStock;
  final int sales;
  final int quantity;
  final double totalPrice;

  CartModel({
    required this.id,
    required this.name,
    required this.image,
    required this.images,
    required this.description,
    required this.status,
    required this.category,
    required this.company,
    required this.price,
    required this.countInStock,
    required this.sales,
    required this.quantity,
    required this.totalPrice,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      category: json['category'] ?? '',
      company: json['company'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      countInStock: json['countInStock'] ?? 0,
      sales: json['sales'] ?? 0,
      quantity: json['quantity'] ?? 0,
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
    );
  }
}

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());
  final Dio dio = Dio();

  Future<String?> _getNationalId() async {
    final prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('nationalId');
    if (id != null) {
      id = id.trim();
    }
    return id;
  }

  Future<void> addToCart(String productId) async {
    emit(CartLoading());
    try {
      final nationalId = await _getNationalId();
      print('CartCubit: Using nationalId: > $nationalId<');
      if (nationalId == null || nationalId.isEmpty) {
        emit(CartError('لم يتم العثور على الرقم القومي. الرجاء تسجيل الدخول أولاً.'));
        return;
      }
      await dio.post(
        "https://elwekala.onrender.com/cart/add",
        data: {
          "nationalId": nationalId,
          "productId": productId,
          "quantity": "1",
        },
      );
      emit(CartSuccess());
      await getCart();
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> getCart() async {
    emit(CartLoading());
    try {
      final nationalId = await _getNationalId();
      print('CartCubit: Using nationalId: >${nationalId}<');
      if (nationalId == null || nationalId.isEmpty) {
        emit(CartError('لم يتم العثور على الرقم القومي. الرجاء تسجيل الدخول أولاً.'));
        return;
      }
      var response = await dio.get(
        "https://elwekala.onrender.com/cart/allProducts",
        queryParameters: {
          "nationalId": nationalId,
        },
      );
      print('getCart response: \n${response.data}');
      List data = response.data["products"];
      List<CartModel> list = data.map((e) => CartModel.fromJson(e)).toList();
      emit(CartUpdated(list));
    } catch (e) {
      if (e is DioError) {
        print('DioError:');
        print('  message: \n${e.message}');
        print('  response: \n${e.response}');
        print('  data: \n${e.response?.data}');
        print('  request: \n${e.requestOptions}');
        print('  uri: \n${e.requestOptions.uri}');
        print('  method: \n${e.requestOptions.method}');
        print('  headers: \n${e.requestOptions.headers}');
      } else {
        print('Error: $e');
      }
      emit(CartError(e.toString()));
    }
  }

  Future<void> deleteFromCart(String productId) async {
    emit(CartLoading());
    try {
      final nationalId = await _getNationalId();
      print('CartCubit: Using nationalId: > 0$nationalId<');
      if (nationalId == null || nationalId.isEmpty) {
        emit(CartError('لم يتم العثور على الرقم القومي. الرجاء تسجيل الدخول أولاً.'));
        return;
      }
      await dio.delete(
        "https://elwekala.onrender.com/cart/delete",
        data: {
          "nationalId": nationalId,
          "productId": productId,
        },
      );
      emit(CartSuccess());
      await getCart();
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> updateCart(String productId, int quantity) async {
    emit(CartLoading());
    try {
      final nationalId = await _getNationalId();
      print('CartCubit: Using nationalId: > 0$nationalId<');
      if (nationalId == null || nationalId.isEmpty) {
        emit(CartError('لم يتم العثور على الرقم القومي. الرجاء تسجيل الدخول أولاً.'));
        return;
      }
      await dio.put(
        "https://elwekala.onrender.com/cart",
        data: {
          "nationalId": nationalId,
          "productId": productId,
          "quantity": quantity,
        },
      );
      emit(CartSuccess());
      await getCart();
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
} 