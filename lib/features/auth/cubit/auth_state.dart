



import '../data/model/response_model.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AddSuccess extends AuthState {
  final ResponseModel  model;

  AddSuccess({required this.model});
}

final class AuthLoading extends AuthState {}
final class AuthImage extends AuthState {}
final class AuthSuccess extends AuthState {}
final class AuthFailure extends AuthState {
  final String error;
  AuthFailure({required this.error});
}
