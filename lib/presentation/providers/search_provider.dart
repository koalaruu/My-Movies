import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/models/movie.dart';
import '../../data/repositories/movie_repository.dart';

class SearchProvider extends ChangeNotifier {
  final MovieRepository _repository = MovieRepository();
  Timer? _debounce;

  List<Movie> results = [];
  bool isLoading = false;
  String? error;
  String query = '';

  void search(String value) {
    query = value;
    notifyListeners();

    _debounce?.cancel();

    if (value.trim().isEmpty) {
      results = [];
      isLoading = false;
      notifyListeners();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      isLoading = true;
      error = null;
      notifyListeners();
      try {
        results = await _repository.searchMovies(value);
      } catch (e) {
        error = e.toString();
      } finally {
        isLoading = false;
        notifyListeners();
      }
    });
  }

  void clearSearch() {
    _debounce?.cancel();
    query = '';
    results = [];
    isLoading = false;
    error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
