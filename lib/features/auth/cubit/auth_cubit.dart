import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../data/auth_data.dart';
import 'auth_state.dart';
AuthData authData =AuthData();


class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit  get( context)=>BlocProvider.of(context);
  File ? image;
  String ? profileImage;
  ImagePicker picker =ImagePicker();
  savedImage() async {

    final picked = await picker.pickImage(source: ImageSource.camera);
    image = File(picked!.path);
    var bytes =  await image!.readAsBytes();
    profileImage = base64Encode(bytes);
    emit(AuthImage());
  }
  registerCubit(
  {
    required String name,
    required String email,
    required String phone,
    required String nationalId,
    required String gender,
    required String password,
}
      )async{
    emit(AuthLoading());
    var model= await authData.register(
        name: name,
        email: email,
        phone: phone,
        nationalId: nationalId,
        gender: gender,
        password: password,
      profileImage: profileImage??"",

    );
    // إذا كان التسجيل ناجح، احفظ nationalId
    if (model.status == "success") {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('nationalId', nationalId.trim());
      // استدعي دالة login لحفظ nationalId وتفعيل AuthSuccess
      await login(nationalId.trim());
    }
    emit(AddSuccess(model: model));
  }

  Future<void> login(String nationalId) async {
    emit(AuthLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('nationalId', nationalId.trim());
      emit(AuthSuccess(nationalId.trim()));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('nationalId');
    emit(AuthInitial());
  }

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('nationalId');
    if (id != null) {
      emit(AuthSuccess(id));
    } else {
      emit(AuthInitial());
    }
  }
}
