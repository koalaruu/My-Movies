import '../models/movie.dart';
import '../models/movie_detail.dart';
import '../services/tmdb_service.dart';

class MovieRepository {
  final TmdbService _service = TmdbService();

  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    try {
      return await _service.getNowPlayingMovies(page: page);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    try {
      return await _service.getPopularMovies(page: page);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  Future<MovieDetail> getMovieDetail(int id) async {
    try {
      return await _service.getMovieDetail(id);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }

  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    try {
      return await _service.searchMovies(query, page: page);
    } catch (e) {
      throw Exception('Repository error: $e');
    }
  }
}
