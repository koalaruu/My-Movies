import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/movie.dart';
import '../../../data/models/movie_detail.dart';
import '../../../data/repositories/movie_repository.dart';
import '../../providers/favorite_provider.dart';

class DetailScreen extends StatefulWidget {
  final int movieId;

  const DetailScreen({super.key, required this.movieId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final MovieRepository _repository = MovieRepository();

  MovieDetail? movieDetail;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final detail = await _repository.getMovieDetail(widget.movieId);
      setState(() {
        movieDetail = detail;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Movie _toMovie(MovieDetail detail) {
    return Movie(
      id: detail.id,
      title: detail.title,
      overview: detail.overview,
      posterPath: detail.posterPath,
      backdropPath: detail.backdropPath,
      voteAverage: detail.voteAverage,
      releaseDate: detail.releaseDate,
      genreIds: detail.genres.map((g) => g.id).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.grey, size: 48),
              const SizedBox(height: 12),
              Text(error!, style: const TextStyle(color: AppColors.kOnSurface)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchDetail,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    final detail = movieDetail!;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: detail.backdropUrl,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Consumer<FavoriteProvider>(
                builder: (context, favoriteProvider, child) {
                  final isFav = favoriteProvider.isFavorite(detail.id);
                  return IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? AppColors.kPrimary : Colors.white,
                    ),
                    onPressed: () => favoriteProvider.toggleFavorite(_toMovie(detail)),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: detail.posterUrl,
                          width: 120,
                          height: 180,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              detail.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            if (detail.tagline.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                detail.tagline,
                                style: const TextStyle(
                                  color: AppColors.kOnSurface,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.star, color: AppColors.kAccent, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  detail.voteAverage.toStringAsFixed(1),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              detail.formattedRuntime,
                              style: const TextStyle(color: AppColors.kOnSurface),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              detail.releaseDate,
                              style: const TextStyle(color: AppColors.kOnSurface),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              detail.originalLanguage.toUpperCase(),
                              style: const TextStyle(color: AppColors.kOnSurface),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: AppColors.kOnSurface),
                  const Text(
                    'Genres:',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: detail.genres
                        .map((g) => Chip(label: Text(g.name)))
                        .toList(),
                  ),
                  const Divider(color: AppColors.kOnSurface),
                  const Text(
                    'Synopsis',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    detail.overview,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(color: AppColors.kOnSurface),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
