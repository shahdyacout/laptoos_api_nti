import '../../home/data/model/cart_model.dart';


abstract class CartState {}

class CartInitial extends CartState {}
class CartLoading extends CartState {}
class CartUpdated extends CartState {
  final List<CartModel> cartItems;
  CartUpdated(this.cartItems);
}
class CartError extends CartState {
  final String error;
  CartError(this.error);
}
class CartSuccess extends CartState {} 