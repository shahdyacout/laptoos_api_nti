import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cart/cubit/cart_cubit.dart';
import '../../../cart/view/cart_screen.dart';
import '../../../favorite/cubit/favorite_cubit.dart';
import '../../../favorite/view/favorite_screen.dart';
import '../../cubit/lap_top_cubit.dart';
import '../../cubit/lap_top_state.dart';
import '../../data/model/laptop_model.dart';

class LaptopsScreen extends StatelessWidget {
  const LaptopsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laptops'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<LaptopsCubit, LaptopsState>(
        builder: (context, state) {
          if (state is LaptopsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LaptopsError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is LaptopsEmpty) {
            return const Center(child: Text('No laptops available.'));
          } else if (state is LaptopsSuccess) {
            return ListView.builder(
              itemCount: state.laptops.length,
              itemBuilder: (context, index) {
                final laptop = state.laptops[index];
                final favoritesCubit = context.read<FavoritesCubit>();
                final cartCubit = context.read<CartCubit>();
                final isFav = favoritesCubit.isFavorite(laptop);

                return Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Image.network(
                            laptop.image,
                            width: 60,
                            errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported),
                          ),
                          title: Text(laptop.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Price: \$${laptop.price.toStringAsFixed(2)}'),
                              const SizedBox(height: 4),
                              Text(
                                laptop.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.red : Colors.grey,
                            ),
                            onPressed: () async {
                              await favoritesCubit.toggleFavorite(laptop);
                              final isNowFav = favoritesCubit.isFavorite(laptop);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(isNowFav
                                      ? 'Added to favorites'
                                      : 'Removed from favorites'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              await cartCubit.addToCart(laptop.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Added to cart"),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add_shopping_cart),
                            label: const Text("Add to Cart"),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
