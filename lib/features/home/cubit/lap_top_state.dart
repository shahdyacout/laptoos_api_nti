
import '../data/model/laptop_model.dart';

sealed class LaptopsState {}

final class LaptopsInitial extends LaptopsState {}

final class LaptopsLoading extends LaptopsState {}

final class LaptopsSuccess extends LaptopsState {
  final List<LaptopModel> laptops;
  LaptopsSuccess(this.laptops);
}

final class LaptopsError extends LaptopsState {
  final String message;
  LaptopsError(this.message);
}

final class LaptopsEmpty extends LaptopsState {}


sealed class LapTopState {}

final class LapTopInitial extends LapTopState {}
