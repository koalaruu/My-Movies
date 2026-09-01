import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../data/models/movie.dart';
import '../constants/app_colors.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final bool isFavorite;

  const MovieCard({
    super.key,
    required this.movie,
    required this.onTap,
    required this.onFavoriteTap,
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: movie.posterUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: AppColors.kSurface,
                ),
                errorWidget: (context, url, error) => Container(
                  color: AppColors.kSurface,
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
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
              Positioned(
                left: 8,
                right: 8,
                bottom: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      movie.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: AppColors.kAccent, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          movie.voteAverage.toStringAsFixed(1),
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          movie.year,
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  onPressed: onFavoriteTap,
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? AppColors.kPrimary : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
