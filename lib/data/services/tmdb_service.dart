import 'package:dio/dio.dart';

import '../../core/constants/api_constants.dart';
import '../models/movie.dart';
import '../models/movie_detail.dart';

class TmdbService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: kBaseUrl,
      queryParameters: {
        'api_key': kApiKey,
        'language': 'en-US',
      },
    ),
  );

  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        '/movie/now_playing',
        queryParameters: {'page': page},
      );
      final results = response.data['results'] as List<dynamic>;
      return results
          .map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Gagal memuat film terbaru: $e');
    }
  }

  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        '/movie/popular',
        queryParameters: {'page': page},
      );
      final results = response.data['results'] as List<dynamic>;
      return results
          .map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Gagal memuat film populer: $e');
    }
  }

  Future<MovieDetail> getMovieDetail(int id) async {
    try {
      final response = await _dio.get('/movie/$id');
      return MovieDetail.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Gagal memuat detail film: $e');
    }
  }

  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    try {
      final response = await _dio.get(
        '/search/movie',
        queryParameters: {'query': query, 'page': page},
      );
      final results = response.data['results'] as List<dynamic>;
      return results
          .map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Gagal mencari film: $e');
    }
  }
}
