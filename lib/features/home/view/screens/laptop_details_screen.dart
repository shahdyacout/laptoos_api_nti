import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/lap_top_cubit.dart';
import '../../cubit/lap_top_state.dart';
import '../../data/model/laptop_model.dart';
import 'home_screen.dart';
import 'laptop_details_screen.dart';
import '../../../favorite/cubit/favorite_cubit.dart';
import '../../../favorite/cubit/favorite_state.dart';
import '../../../cart/cubit/cart_state.dart';
import '../../../favorite/view/favorite_screen.dart';
import '../../../cart/view/cart_screen.dart';
import 'package:badges/badges.dart' as badges;

class LaptopScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoriteCubit = context.read<FavoritesCubit>();
    final cartCubit = context.read<CartCubit>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Laptop Store',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(
                  favoriteCubit.favorites.isNotEmpty
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                  );
                },
              );
            },
          ),
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              int cartCount = 0;
              if (state is CartUpdated) {
                cartCount = state.cartItems.length;
              }
              return badges.Badge(
                showBadge: cartCount > 0,
                badgeContent: Text(
                  '$cartCount',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                position: badges.BadgePosition.topEnd(top: -8, end: -8),
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart, color: Colors.white),
                  onPressed: () {
                    context.read<CartCubit>().getCart();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CartScreen()),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: BlocProvider(
        create: (context) => LaptopsCubit(context.read())..getLaptops(),
        child: BlocBuilder<LaptopsCubit, LaptopsState>(
          builder: (context, state) {
            if (state is LaptopsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LaptopsSuccess) {
              final laps = state.laptops;
              return Padding(
                padding: const EdgeInsets.all(12),
                child: GridView.builder(
                  itemCount: laps.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    final laptop = laps[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 75), // space below card
                      child: LaptopItemCard(laptop: laptop),
                    );
                  },
                ),
              );
            } else if (state is LaptopsError) {
              return Center(child: Text("Error: ${state.message}"));
            } else if (state is LaptopsEmpty) {
              return const Center(child: Text("No laptops to show."));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}

class LaptopItemCard extends StatelessWidget {
  final LaptopModel laptop;
  const LaptopItemCard({super.key, required this.laptop});

  @override
  Widget build(BuildContext context) {
    final favoriteCubit = context.read<FavoritesCubit>();
    final cartCubit = context.read<CartCubit>();
    final isFav = favoriteCubit.isFavorite(laptop);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: laptop.image,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 1.3,
                child: Image.network(
                  laptop.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.laptop, size: 64),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  laptop.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  laptop.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "\$${laptop.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          cartCubit.addToCart(laptop.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${laptop.title} added to cart!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Icon(Icons.shopping_cart,
                            size: 20, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : Colors.grey,
                      ),
                      onPressed: () async {
                        await favoriteCubit.toggleFavorite(laptop);
                        final newIsFav = favoriteCubit.isFavorite(laptop);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(newIsFav
                                ? 'Added to favorite'
                                : 'Removed from favorite'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                // حذفت الـ SizedBox(height: 40) لأنها مش لازمة لما ندي margin للكارد من بره
              ],
            ),
          ),
        ],
      ),
    );
  }
}
