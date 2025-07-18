import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';



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
    emit(AddSuccess(model: model));
  }
  void login(String nationalId) async {
    emit(AuthLoading());

    try {
      final result = await authData.login(nationalId); // لسه هنعملها كمان شوية
      if (result != null) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure(error: "Invalid ID or user not found."));
      }
    } catch (e) {
      emit(AuthFailure(error: e.toString()));
    }
  }
  void checkLogin() {
    // مثال على التحقق، حسب ما هتعملي منطقك
    if (/* أي شرط */ false) {
      emit(AuthSuccess());
    } else {
      emit(AuthInitial());
    }
  }

}
