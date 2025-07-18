import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/dio_helprt.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'features/auth/cubit/auth_state.dart';
import 'features/auth/view/login_screen.dart';
import 'features/home/data/model/favorite_data.dart';
import 'features/home/view/screens/home_screen.dart';
import 'features/favorite/cubit/favorite_cubit.dart';
import 'features/cart/cubit/cart_cubit.dart';
import 'features/home/view/screens/laptop_details_screen.dart';
import 'package:provider/provider.dart';

// أضف الاستيرادين التاليين حسب المسار الصحيح في مشروعك
import 'features/home/data/lap_data.dart';
import 'features/home/cubit/lap_top_cubit.dart';

final dio = DioHelper.createDio();
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => AuthCubit()..checkLogin()),
        BlocProvider<FavoritesCubit>(create: (_) =>FavoritesCubit(FavoriteRepo(dio))),
        BlocProvider<CartCubit>(create: (_) => CartCubit()),
        Provider<LaptopRepo>(create: (_) => LaptopRepo(dio)),
        BlocProvider<LaptopsCubit>(
          create: (context) => LaptopsCubit(context.read<LaptopRepo>()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NTI API Demo',
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthSuccess) {
              return LaptopScreen();
            } else {
              return const LoginScreen();
            }
          },
        ),
        routes: {
          '/home': (_) => LaptopScreen(),
        },
      ),
    );
  }
}