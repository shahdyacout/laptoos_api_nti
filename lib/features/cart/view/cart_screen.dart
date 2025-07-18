import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home/view/screens/home_screen.dart';
import '../cubit/cart_state.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    // جلب السلة عند فتح الصفحة
    Future.microtask(() => BlocProvider.of<CartCubit>(context).getCart());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart'), backgroundColor: Colors.deepPurple, centerTitle: true),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartUpdated) {
            final cartItems = state.cartItems; // List<CartModel>
            if (cartItems.isEmpty) {
              return const Center(child: Text('Cart is empty.', style: TextStyle(fontSize: 18)));
            }
            return ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index]; // CartModel
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  elevation: 3,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepPurple[100],
                      backgroundImage: NetworkImage(item.image),
                      child: const Icon(Icons.laptop, color: Colors.deepPurple),
                    ),
                    title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                if (item.quantity > 1) {
                                  context.read<CartCubit>().updateCart(item.id, item.quantity - 1);
                                }
                              },
                            ),
                            Text('Quantity: ${item.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () {
                                context.read<CartCubit>().updateCart(item.id, item.quantity + 1);
                              },
                            ),
                          ],
                        ),
                        Text('Price: ${item.price}'),
                        Text('Total: ${item.totalPrice.toStringAsFixed(2)}', style: const TextStyle(color: Colors.teal)),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await context.read<CartCubit>().deleteFromCart(item.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Removed from cart')),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          } else if (state is CartError) {
            return Center(child: Text('Error: ${state.error}', style: TextStyle(color: Colors.red)));
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.read<CartCubit>().getCart(),
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.refresh),
        label: const Text('Refresh'),
      ),
    );
  }
} 