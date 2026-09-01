import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/logout_button.dart';
import '../../providers/favorite_provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kBackground,
        title: const Text('Favoritku'),
        actions: [
          Consumer<FavoriteProvider>(
            builder: (context, favoriteProvider, child) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Badge(
                    label: Text('${favoriteProvider.favorites.length}'),
                    child: const Icon(Icons.favorite),
                  ),
                ),
              );
            },
          ),
          const LogoutButton(),
        ],
      ),
      body: Consumer<FavoriteProvider>(
        builder: (context, favoriteProvider, child) {
          if (favoriteProvider.favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum ada film favorit',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Tekan ❤️ di film manapun untuk menyimpannya di sini',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.kOnSurface,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => context.go('/home'),
                    child: const Text('Jelajahi Film'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: favoriteProvider.favorites.length,
            itemBuilder: (context, index) {
              final movie = favoriteProvider.favorites[index];
              return Dismissible(
                key: ValueKey(movie.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: AppColors.kPrimary,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  favoriteProvider.toggleFavorite(movie);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${movie.title} dihapus dari favorit'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () => favoriteProvider.toggleFavorite(movie),
                      ),
                    ),
                  );
                },
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: movie.posterUrl,
                      width: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: AppColors.kAccent,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        movie.voteAverage.toStringAsFixed(1),
                        style: const TextStyle(color: AppColors.kOnSurface),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        movie.year,
                        style: const TextStyle(color: AppColors.kOnSurface),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: AppColors.kPrimary),
                    onPressed: () => favoriteProvider.toggleFavorite(movie),
                  ),
                  onTap: () => context.go('/home/detail/${movie.id}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
