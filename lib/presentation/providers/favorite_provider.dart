import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/movie.dart';

class FavoriteProvider extends ChangeNotifier {
  static const String _favoritesKey = 'favorites';

  List<Movie> favorites = [];

  FavoriteProvider() {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_favoritesKey) ?? [];
    favorites = stored
        .map((e) => Movie.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .toList();
    notifyListeners();
  }

  Future<void> toggleFavorite(Movie movie) async {
    final prefs = await SharedPreferences.getInstance();
    final exists = favorites.any((m) => m.id == movie.id);
    if (exists) {
      favorites = favorites.where((m) => m.id != movie.id).toList();
    } else {
      favorites = [...favorites, movie];
    }
    final stored = favorites.map((m) => jsonEncode(m.toJson())).toList();
    await prefs.setStringList(_favoritesKey, stored);
    notifyListeners();
  }

  bool isFavorite(int movieId) {
    return favorites.any((m) => m.id == movieId);
  }
}
