import 'package:dio/dio.dart';

import 'model/laptop_model.dart';


class LaptopRepo {
  final Dio dio;

  LaptopRepo(this.dio);

  Future<List<LaptopModel>> getLaptops() async {
    print('LaptopRepo: Fetching laptops...');
    var response = await dio.get("https://elwekala.onrender.com/product/Laptops");
    print('LaptopRepo: Response: \\${response.data}');
    // استخراج الليست من جوه الـ Map
    List data = response.data['product']; //

    return data.map((e) => LaptopModel.fromJson(e)).toList();
  }

}
