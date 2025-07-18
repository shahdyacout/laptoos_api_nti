
import '../../home/data/model/laptop_model.dart';

sealed class FavoritesState {}

final class FavoritesInitial extends FavoritesState {}

final class FavoritesLoading extends FavoritesState {}

final class FavoritesSuccess extends FavoritesState {
  final List<LaptopModel> favorites;
  FavoritesSuccess(this.favorites);
}

final class FavoritesError extends FavoritesState {
  final String message;
  FavoritesError(this.message);
}
