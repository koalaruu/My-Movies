import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/logout_button.dart';
import '../../../core/widgets/movie_card.dart';
import '../../providers/favorite_provider.dart';
import '../../providers/search_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    context.read<SearchProvider>().clearSearch();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.kBackground,
          title: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Cari film...',
              hintStyle: const TextStyle(color: AppColors.kOnSurface),
              prefixIcon: const Icon(Icons.search, color: Colors.white),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white),
                      onPressed: () {
                        _searchController.clear();
                        context.read<SearchProvider>().clearSearch();
                        setState(() {});
                      },
                    )
                  : null,
              border: InputBorder.none,
            ),
            onChanged: (value) {
              context.read<SearchProvider>().search(value);
              setState(() {});
            },
          ),
          actions: const [LogoutButton()],
        ),
        body: Consumer<SearchProvider>(
          builder: (context, searchProvider, child) {
            if (searchProvider.query.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.movie, size: 64, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      'Cari film favoritmu',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Ketik judul film untuk mencari',
                      style: TextStyle(
                        color: AppColors.kOnSurface,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (searchProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (searchProvider.results.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.search_off, size: 64, color: Colors.grey),
                    const SizedBox(height: 12),
                    Text(
                      'Tidak ada hasil untuk "${searchProvider.query}"',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            }

            return Consumer<FavoriteProvider>(
              builder: (context, favoriteProvider, child) {
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: searchProvider.results.length,
                  itemBuilder: (context, index) {
                    final movie = searchProvider.results[index];
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
            );
          },
        ),
      ),
    );
  }
}
