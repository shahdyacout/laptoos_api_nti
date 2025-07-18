import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/favorite_cubit.dart';
import '../cubit/favorite_state.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Favorites')),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FavoritesError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is FavoritesSuccess) {
            final favoritesCubit = context.read<FavoritesCubit>();
            final favorites = state.favorites;

            if (favorites.isEmpty) {
              return const Center(child: Text('No favorites yet.'));
            }

            return ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final laptop = favorites[index];

                return Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Image.network(
                      laptop.image,
                      width: 60,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported),
                    ),
                    title: Text(laptop.title),
                    subtitle: Text(
                      laptop.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        await favoritesCubit.removeFavoriteItem(laptop.id);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Removed from favorites'),
                            duration: Duration(seconds: 1),
                          ),
                        );

                        if (favoritesCubit.favorites.isEmpty) {
                          Navigator.pop(context); // يرجع لو مفيش عناصر تاني
                        }
                      },
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
