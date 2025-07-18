import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../auth/cubit/auth_cubit.dart';
import '../../auth/cubit/auth_state.dart';
import '../../home/data/lap_data.dart';
import '../../home/view/screens/laptop_details_screen.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  final repo = LaptopRepo(Dio());
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController nationalIdController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, state) {
            var cubit= AuthCubit.get(context);

            return Column(
              children: [
           cubit.     image == null ? Text("no image") : Image.file(cubit.image!),
                IconButton(onPressed: () {
                  context.read<AuthCubit>().savedImage();
                },
                    icon: Icon(Icons.add_a_photo, size: 60,)),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: "Name"),
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(hintText: "Email"),
                ),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(hintText: "Phone"),
                ),
                TextFormField(
                  controller: nationalIdController,
                  decoration: const InputDecoration(hintText: "National ID"),
                ),
                TextFormField(
                  controller: genderController,
                  decoration: const InputDecoration(hintText: "Gender"),
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: "Password"),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: BlocListener<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state is AddSuccess) {
                        if (state.model.status == "error") {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.model.message)));
                        }
                      }
                    },
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<AuthCubit>().registerCubit(
                          name: nameController.text.trim(),
                          email: emailController.text.trim(),
                          phone: phoneController.text.trim(),

                          gender: genderController.text.trim(),
                          password: passwordController.text.trim(),
                          nationalId: nationalIdController.text.trim(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }, listener: (BuildContext context, AuthState state) {
            if(state is AddSuccess){
              Navigator.push(context, MaterialPageRoute(builder: (C){
                return LaptopScreen();
              }));
            }
        },
        ),
      ),
    );
  }
}
