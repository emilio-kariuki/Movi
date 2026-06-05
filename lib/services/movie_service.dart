import 'package:http/http.dart' as http;
import 'package:stacked/stacked.dart';
import '../models/cast_model.dart';
import '../models/genres_model.dart';
import '../models/keywords_model.dart';
import '../models/movie_casts_model.dart';
import '../models/movie_details_model.dart';
import '../models/movie_genre_model.dart';
import '../models/movie_model.dart';
import '../models/movie_trailer.dart';
import '../models/review_model.dart';
import '../models/search_movie_model.dart';
import '../models/trending_model.dart';
import '../models/user_films_model.dart';

const String _apiKey = '502e894cf5940df8a65af3537e812b5c';
const String _base = 'https://api.themoviedb.org/3';

class MovieService with ReactiveServiceMixin {
  MovieModel? _popular;
  Trending? _trending;
  MovieModel? _topRated;
  Genres? _genres;

  MovieModel? _popularPage;
  MovieModel? _topRatedPage;
  Trending? _trendingPage;
  MovieModel? _genreMovies;
  MovieModel? _keywordMovies;

  SearchModel? _searchResults;

  Movie? _currentMovieDetails;
  Cast? _currentMovieCasts;
  MovieModel? _currentSimilar;
  Trailer? _currentTrailer;
  Keywords? _currentKeywords;
  Review? _currentReviews;

  CastModel? _currentCast;
  UserFilms? _currentCastFilms;

  MovieModel? get popular => _popular;
  Trending? get trending => _trending;
  MovieModel? get topRated => _topRated;
  Genres? get genres => _genres;

  MovieModel? get popularPage => _popularPage;
  MovieModel? get topRatedPage => _topRatedPage;
  Trending? get trendingPage => _trendingPage;
  MovieModel? get genreMovies => _genreMovies;
  MovieModel? get keywordMovies => _keywordMovies;

  SearchModel? get searchResults => _searchResults;

  Movie? get currentMovieDetails => _currentMovieDetails;
  Cast? get currentMovieCasts => _currentMovieCasts;
  MovieModel? get currentSimilar => _currentSimilar;
  Trailer? get currentTrailer => _currentTrailer;
  Keywords? get currentKeywords => _currentKeywords;
  Review? get currentReviews => _currentReviews;

  CastModel? get currentCast => _currentCast;
  UserFilms? get currentCastFilms => _currentCastFilms;

  Future<String> _get(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) return response.body;
    throw Exception(response.body);
  }

  Future<void> fetchHomeData({required int page}) async {
    final results = await Future.wait([
      _get(
          '$_base/trending/all/day?api_key=$_apiKey&page=$page&language=en-US'),
      _get('$_base/movie/popular?api_key=$_apiKey&page=$page&language=en-US'),
      _get(
          '$_base/movie/top_rated?api_key=$_apiKey&page=${page}l&language=en-US'),
      _get('$_base/genre/movie/list?api_key=$_apiKey&language=en-US&page=1l'),
    ]);
    _trending = trendingFromJson(results[0]);
    _popular = movieModelFromJson(results[1]);
    _topRated = movieModelFromJson(results[2]);
    _genres = genresFromJson(results[3]);
    notifyListeners();
  }

  Future<void> fetchMovieDetails({required int id}) async {
    final results = await Future.wait([
      _get('$_base/movie/$id?api_key=$_apiKey&language=en-US&page=1'),
      _get('$_base/movie/$id/credits?api_key=$_apiKey'),
      _get('$_base/movie/$id/similar?api_key=$_apiKey&language=en-US'),
      _get('$_base/movie/$id/videos?api_key=$_apiKey&language=en-US&page=1'),
      _get('$_base/movie/$id/keywords?api_key=$_apiKey&language=en-US&page=1'),
      _get('$_base/movie/$id/reviews?api_key=$_apiKey&page=1l&language=en-US'),
    ]);
    _currentMovieDetails = movieFromJson(results[0]);
    _currentMovieCasts = castFromJson(results[1]);
    _currentSimilar = movieModelFromJson(results[2]);
    _currentTrailer = trailerFromJson(results[3]);
    _currentKeywords = keywordsFromJson(results[4]);
    _currentReviews = reviewFromJson(results[5]);
    notifyListeners();
  }

  Future<void> fetchPopularPage({required int page}) async {
    final data = await _get(
        '$_base/movie/popular?api_key=$_apiKey&page=$page&language=en-US');
    _popularPage = movieModelFromJson(data);
    notifyListeners();
  }

  Future<void> fetchTopRatedPage({required int page}) async {
    final data = await _get(
        '$_base/movie/top_rated?api_key=$_apiKey&page=${page}l&language=en-US');
    _topRatedPage = movieModelFromJson(data);
    notifyListeners();
  }

  Future<void> fetchTrendingPage({required int page}) async {
    final data = await _get(
        '$_base/trending/all/day?api_key=$_apiKey&page=$page&language=en-US');
    _trendingPage = trendingFromJson(data);
    notifyListeners();
  }

  Future<void> fetchGenreMovies({required int id, required int page}) async {
    final data = await _get(
        '$_base/discover/movie?api_key=$_apiKey&language=en-US&page=$page&with_genres=$id');
    _genreMovies = movieModelFromJson(data);
    notifyListeners();
  }

  Future<void> fetchKeywordMovies({required int id, required int page}) async {
    final data = await _get(
        '$_base/discover/movie?api_key=$_apiKey&language=en-US&page=$page&with_keywords=$id');
    _keywordMovies = movieModelFromJson(data);
    notifyListeners();
  }

  Future<void> fetchSearchResults(
      {required String title, required int page}) async {
    final data = await _get(
        '$_base/search/movie?api_key=$_apiKey&query=$title&language=en-US&page=$page');
    _searchResults = searchModelFromJson(data);
    notifyListeners();
  }

  Future<void> fetchCastDetails({required int id}) async {
    final results = await Future.wait([
      _get('$_base/person/$id?api_key=$_apiKey&language=en-US&page=1'),
      _get(
          '$_base/person/$id/movie_credits?api_key=$_apiKey&language=en-US&page=1'),
    ]);
    _currentCast = castModelFromJson(results[0]);
    _currentCastFilms = userFilmsFromJson(results[1]);
    notifyListeners();
  }

  Future<MovieGenre> getMovieGenre() async {
    final data = await _get(
        '$_base/discover/movie?api_key=$_apiKey&language=en-US&page=1&sort_by=popularity.desc');
    return movieGenreFromJson(data);
  }
}
