import 'package:flutter/material.dart';
import 'package:movi/models/GenreMovieModel.dart';
import 'package:movi/models/GenresModel.dart';
import 'package:movi/models/KeywordsModel.dart';
import 'package:movi/models/MovieCastsModel.dart';
import 'package:movi/models/MovieDetailsModel.dart';
import 'package:movi/models/MovieGenreModel.dart';
import 'package:movi/models/MovieModel.dart';
import 'package:http/http.dart' as http;
import 'package:movi/models/MovieTrailer.dart';
import 'package:movi/models/ReviewModel.dart';
import 'package:movi/models/SearchMovieModel.dart';
import 'package:movi/models/TrendingModel.dart';
import 'package:movi/models/UserFilmsModel.dart';
import 'package:movi/models/CastModel.dart';

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

  static Future<MovieModel> getMoviesInGenre(
      {required int id, required int page}) async {
    String response = await getResponse(
        url:
            "https://api.themoviedb.org/3/discover/movie?api_key=502e894cf5940df8a65af3537e812b5c&language=en-US&page=$page&with_genres=$id");
    return movieModelFromJson(response);
  }

  static Future<MovieModel> getPopularMovies({int page = 1}) async {
    String response = await getResponse(
      url:
          "https://api.themoviedb.org/3/movie/popular?api_key=502e894cf5940df8a65af3537e812b5c&page=$page&language=en-US",
    );
    return movieModelFromJson(response);
  }

  static Future<Trending> getTrendingMovies({int page = 1}) async {
    String response = await getResponse(
      url:
          "https://api.themoviedb.org/3/trending/all/day?api_key=502e894cf5940df8a65af3537e812b5c&page=${page}&language=en-US",
    );

    return trendingFromJson(response);
  }

  static Future<Keywords> getMovieKeywords({required int id}) async {
    String response = await getResponse(
      url:
          "https://api.themoviedb.org/3/movie/$id/keywords?api_key=502e894cf5940df8a65af3537e812b5c&language=en-US&page=1",
    );

    return keywordsFromJson(response);
  }

  static Future<MovieModel> getTopRatedMovies({int page = 1}) async {
    String response = await getResponse(
      url:
          "https://api.themoviedb.org/3/movie/top_rated?api_key=502e894cf5940df8a65af3537e812b5c&page=${page}l&language=en-US",
    );
    return movieModelFromJson(response);
  }

  static Future<Review> getMovieReviews({int page = 1, required int id}) async {
    String response = await getResponse(
      url:
          "https://api.themoviedb.org/3/movie/$id/reviews?api_key=502e894cf5940df8a65af3537e812b5c&page=${page}l&language=en-US",
    );
    return reviewFromJson(response);
  }

  static Future<Genres> getGenres() async {
    String response = await getResponse(
      url:
          "https://api.themoviedb.org/3/genre/movie/list?api_key=502e894cf5940df8a65af3537e812b5c&language=en-US&page=1l",
    );
    return genresFromJson(response);
  }

  static Future<Movie> getMovieDetails({int id = 29}) async {
    String response = await getResponse(
        url:
            "https://api.themoviedb.org/3/movie/$id?api_key=502e894cf5940df8a65af3537e812b5c&language=en-US&page=1");

    return movieFromJson(response);
  }

  static Future<Trailer> getMovieTrailers({int id = 29}) async {
    String response = await getResponse(
        url:
            "https://api.themoviedb.org/3/movie/$id/videos?api_key=502e894cf5940df8a65af3537e812b5c&language=en-US&page=1");

    return trailerFromJson(response);
  }

  static Future<Cast> getMovieCasts({int id = 29}) async {
    String response = await getResponse(
        url:
            "https://api.themoviedb.org/3/movie/$id/credits?api_key=502e894cf5940df8a65af3537e812b5c");

    return castFromJson(response);
  }

  static Future<MovieModel> getMovieSimilar({required int id}) async {
    String response = await getResponse(
        url:
            "https://api.themoviedb.org/3/movie/$id/similar?api_key=502e894cf5940df8a65af3537e812b5c&language=en-US");

    return movieModelFromJson(response);
  }

  static Future<CastModel> getUser({required int id}) async {
    String response = await getResponse(
        url:
            "https://api.themoviedb.org/3/person/$id?api_key=502e894cf5940df8a65af3537e812b5c&language=en-US&page=1");

    return castModelFromJson(response);
  }

  static Future<UserFilms> getUserFilms({required int id}) async {
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

  static Future<SearchModel> getSearchMovie(
      {required String title, required int page}) async {
    String response = await getResponse(
        url:
            "https://api.themoviedb.org/3/search/movie?api_key=502e894cf5940df8a65af3537e812b5c&language=en-US&page=$page&query=$title");

    return searchModelFromJson(response);
  }
}
