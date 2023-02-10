import 'package:flutter/material.dart';
import 'package:movistar/models/GenreMovieModel.dart';
import 'package:movistar/models/MovieCastsModel.dart';
import 'package:movistar/models/MovieDetailsModel.dart';
import 'package:movistar/models/MovieGenreModel.dart';
import 'package:movistar/models/PopularModel.dart';
import 'package:http/http.dart' as http;
import 'package:movistar/models/SimilarMovieModel.dart';
import 'package:movistar/models/TopRatedModel.dart';
import 'package:movistar/models/TrendingModel.dart';
import 'package:movistar/models/UserFilmsModel.dart';
import 'package:movistar/models/userModel.dart';

class Repository {
  static Future<String> getResponse({required String url}) async {
    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = response.body;
        return data;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  static Future<Popular> getPopularMovies({int page = 1}) async {
    String response = await getResponse(
      url:
          "https://api.themoviedb.org/3/movie/popular?api_key=502e894cf5940df8a65af3537e812b5c&page=$page&language=en-US",
    );
    debugPrint(response);
    return popularFromJson(response);
  }

  static Future<Trending> getTrendingMovies({int page = 1}) async {
    String response = await getResponse(
      url:
          "https://api.themoviedb.org/3/trending/all/day?api_key=502e894cf5940df8a65af3537e812b5c&page=${page}&language=en-US",
    );
    
    return trendingFromJson(response);
  }

  static Future<TopRated> getTopRatedMovies({int page = 1}) async {
    String response = await getResponse(
      url:
          "https://api.themoviedb.org/3/movie/top_rated?api_key=502e894cf5940df8a65af3537e812b5c&page=${page}l&language=en-US",
    );
    return topRatedFromJson(response);
  }

  static Future<GenreMovie> getGenreMovies(
      {int page = 1, int genre = 27}) async {
    String response = await getResponse(
      url:
          "https://api.themoviedb.org/3/list/$genre?api_key=502e894cf5940df8a65af3537e812b5c&language=en-US&page=${page}l",
    );
    return genreMovieFromJson(response);
  }

  static Future<Movie> getMovieDetails({int id = 29}) async {
    String response = await getResponse(
        url:
            "https://api.themoviedb.org/3/movie/$id?api_key=502e894cf5940df8a65af3537e812b5c&language=en-US&page=1");

    return movieFromJson(response);
  }

  static Future<Cast> getMovieCasts({int id = 29}) async {
    String response = await getResponse(
        url:
            "https://api.themoviedb.org/3/movie/$id/credits?api_key=502e894cf5940df8a65af3537e812b5c");

    return castFromJson(response);
  }

  static Future<Similar> getMovieSimilar({required int id} ) async {
    String response = await getResponse(
        url:
            "https://api.themoviedb.org/3/movie/$id/similar?api_key=502e894cf5940df8a65af3537e812b5c&language=en-US");

    return similarFromJson(response);
  }

  static Future<User> getUser({required int id} ) async {
    String response = await getResponse(
        url:
            "https://api.themoviedb.org/3/person/$id?api_key=502e894cf5940df8a65af3537e812b5c&language=en-US&page=1");

    return userFromJson(response);
  }

  static Future<UserFilms> getUserFilms({required int id} ) async {
    String response = await getResponse(
        url:
            "https://api.themoviedb.org/3/person/$id/movie_credits?api_key=502e894cf5940df8a65af3537e812b5c&language=en-US&page=1");

    return userFilmsFromJson(response);
  }

  static Future<MovieGenre> getMovieGenre() async {
    String response = await getResponse(
        url:
            "https://api.themoviedb.org/3/genre/movie/list?api_key=502e894cf5940df8a65af3537e812b5c&language=en-US&page=1l");

    return movieGenreFromJson(response);
  }


}
