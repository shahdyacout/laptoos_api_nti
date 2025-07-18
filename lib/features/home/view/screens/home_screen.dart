import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../cart/cubit/cart_state.dart';
import '../../data/model/cart_model.dart';


class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());
  final Dio dio = Dio();

  _getNationalId() async {
    final prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString('nationalId');
    if (id != null) {
      id = id.trim();
    }
    return id;
  }

  Future<void> addToCart(String productId) async {
    emit(CartLoading());
    // try {
    //   final nationalId = await _getNationalId();
    //   print('CartCubit: Using nationalId: > $nationalId<');
    //   if (nationalId == null || nationalId.isEmpty) {
    //     emit(CartError('لم يتم العثور على الرقم القومي. الرجاء تسجيل الدخول أولاً.'));
    //     return;

    var repo = await dio.post(
      "https://elwekala.onrender.com/cart/add",
      data: {
        "nationalId": "01009876567876",
        "productId": productId,
        "quantity": "1",
      },
    );
    print(repo.data);
    print(repo.data);
    print(repo.data);
    print(repo.data);
    print(repo.data);
    print(repo.data);
    print(repo.data);
    print(repo.data);
    print(repo.data);
    print(repo.data);
    emit(CartSuccess());
    print(repo.data);
    print(repo.data);
    print(repo.data);
    print(repo.data);
    print(repo.data);
    print(repo.data);
    print(repo.data);
    print(repo.data);
    print(repo.data);
    print(repo.data);
    await getCart();
  }


  Future<void> getCart() async {
    emit(CartLoading());

    var response = await dio.get(
      "https://elwekala.onrender.com/cart/allProducts",
      data: {
        "nationalId": "01009876567876",        },
    );
    print('getCart response: \n${response.data}');
    List data = response.data["products"];
    List<CartModel> list = data.map((e) => CartModel.fromJson(e)).toList();
    emit(CartUpdated(list));
  }



  Future<void> deleteFromCart(String productId) async {
    emit(CartLoading());

    await dio.delete(
      "https://elwekala.onrender.com/cart/delete",
      data: {
        "nationalId": "01009876567876",
        "productId": productId,
      },
    );
    emit(CartSuccess());
    await getCart();

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