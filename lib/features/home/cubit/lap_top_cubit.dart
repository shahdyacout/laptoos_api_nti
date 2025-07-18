import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/lap_data.dart';
import 'lap_top_state.dart';



class LaptopsCubit extends Cubit<LaptopsState> {
  final LaptopRepo repo;

  LaptopsCubit(this.repo) : super(LaptopsInitial());

  void getLaptops() async {
    emit(LaptopsLoading());
    print('LaptopsCubit: Loading...');
    try {
      final laptops = await repo.getLaptops();
      print('LaptopsCubit: Data received: \\${laptops.length}');
      if (laptops.isEmpty) {
        emit(LaptopsEmpty());
        print('LaptopsCubit: Empty');
      } else {
        emit(LaptopsSuccess(laptops));
        print('LaptopsCubit: Success');
      }
    } catch (e) {
      emit(LaptopsError(e.toString()));
      print('LaptopsCubit: Error \\${e.toString()}');
    }
  }
}
