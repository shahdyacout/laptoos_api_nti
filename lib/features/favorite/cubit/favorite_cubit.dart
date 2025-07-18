import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/dio_helprt.dart';
import '../../home/data/model/favorite_data.dart';
import '../../home/data/model/laptop_model.dart';
import 'favorite_state.dart';
import 'package:dio/dio.dart';


class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoriteRepo repo;
  List<LaptopModel> _favorites = [];
  final dio = DioHelper.createDio();
  FavoritesCubit(this.repo) : super(FavoritesInitial());

  /// تحميل الفيفوريت من السيرفر
  Future<void> loadFavorites() async {
    emit(FavoritesLoading());
    try {
      _favorites = await repo.getFavorites();
      emit(FavoritesSuccess(_favorites));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  /// التبديل بين إضافة/حذف عنصر من الفيفوريت
  Future<void> toggleFavorite(LaptopModel laptop) async {
    try {
      if (isFavorite(laptop)) {
        await repo.removeFavorite(laptop.id);
        _favorites.removeWhere((e) => e.id == laptop.id);
      } else {
        await repo.addFavorite(laptop.id);
        _favorites.add(laptop);
      }
      emit(FavoritesSuccess(List.from(_favorites)));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  /// حذف عنصر صريح من الفيفوريت (من شاشة الفيفوريت مباشرة)
  Future<void> removeFavoriteItem(String productId) async {
    try {
      await repo.removeFavorite(productId);
      _favorites.removeWhere((e) => e.id == productId);
      emit(FavoritesSuccess(List.from(_favorites)));
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  /// فحص هل المنتج موجود بالفعل في الفيفوريت
  bool isFavorite(LaptopModel laptop) {
    return _favorites.any((e) => e.id == laptop.id);
  }

  /// الوصول لقائمة الفيفوريت
  List<LaptopModel> get favorites => List.unmodifiable(_favorites);
}
