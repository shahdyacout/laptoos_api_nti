import 'dart:convert';

import 'package:dio/dio.dart';

import 'model/response_model.dart';

class AuthData{
  final Dio dio =Dio();
  register (
  {

    required String name,
    required String email,
    required  String phone,
    required String nationalId,
    required String gender,
    required String password,
    required String profileImage,

  }
      ) async{
try {

  var response=  await dio.post("https://elwekala.onrender.com/user/register",
      data : {

        "name": name,
        "email": email,
        "phone":phone,
        "nationalId":nationalId,
        "gender": gender,
        "password": password,
        "profileImage":
profileImage      }
  );
  var data =response.data;

  var model = ResponseModel.fromJson(data);
  return model;
} on DioException catch (e) {
  if (e.response != null) {
    var error = e.response!.data;
    var modelError = ResponseModel.fromJson(error);
    return modelError;
  }
}

  }
  Future<bool?> login(String nationalId) async {
    // دي محاكاة login، لازم تغيرها بالـ API الحقيقي
    if (nationalId == "01001234567890") {
      return true;
    } else {
      return false;
    }
  }

}