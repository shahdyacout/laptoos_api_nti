


import '../data/model/response_model.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final String nationalId;
  AuthSuccess(this.nationalId);
}
class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}
// دعم شاشة التسجيل القديمة
class AddSuccess extends AuthState {
  final ResponseModel model;
  AddSuccess({required this.model});
}
class AuthImage extends AuthState {}
