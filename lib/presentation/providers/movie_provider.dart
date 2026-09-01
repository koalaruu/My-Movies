import 'package:flutter/material.dart';

import '../../data/models/movie.dart';
import '../../data/repositories/movie_repository.dart';

class MovieProvider extends ChangeNotifier {
  final MovieRepository _repository = MovieRepository();

  List<Movie> movies = [];
  bool isLoading = false;
  String? error;
  int currentPage = 1;
  bool hasMore = true;

  Future<void> loadMovies() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      currentPage = 1;
      movies = await _repository.getNowPlayingMovies(page: currentPage);
      hasMore = true;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (isLoading || !hasMore) return;
    isLoading = true;
    notifyListeners();
    try {
      final nextPage = currentPage + 1;
      final newMovies = await _repository.getNowPlayingMovies(page: nextPage);
      if (newMovies.isEmpty) {
        hasMore = false;
      } else {
        currentPage = nextPage;
        movies = [...movies, ...newMovies];
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    movies = [];
    currentPage = 1;
    hasMore = true;
    await loadMovies();
  }
}
