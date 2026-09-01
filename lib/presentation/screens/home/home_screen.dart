import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/loading_shimmer.dart';
import '../../../core/widgets/logout_button.dart';
import '../../../core/widgets/movie_card.dart';
import '../../providers/favorite_provider.dart';
import '../../providers/movie_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieProvider>().loadMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kBackground,
        title: const Text(
          'MyMovies',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.kPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.go('/search'),
          ),
          const LogoutButton(),
        ],
      ),
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          if (movieProvider.isLoading && movieProvider.movies.isEmpty) {
            return const LoadingShimmer();
          }

          if (movieProvider.error != null && movieProvider.movies.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.grey, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    movieProvider.error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.kOnSurface),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => movieProvider.loadMovies(),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => movieProvider.refresh(),
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.metrics.pixels >=
                    notification.metrics.maxScrollExtent * 0.8) {
                  movieProvider.loadMore();
                }
                return false;
              },
              child: Consumer<FavoriteProvider>(
                builder: (context, favoriteProvider, child) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemCount: movieProvider.movies.length,
                    itemBuilder: (context, index) {
                      final movie = movieProvider.movies[index];
                      return MovieCard(
                        movie: movie,
                        onTap: () => context.go('/home/detail/${movie.id}'),
                        onFavoriteTap: () =>
                            favoriteProvider.toggleFavorite(movie),
                        isFavorite: favoriteProvider.isFavorite(movie.id),
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
