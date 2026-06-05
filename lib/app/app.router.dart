import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import '../ui/views/cast_details/cast_details_view.dart';
import '../ui/views/favourites/favourites_view.dart';
import '../ui/views/genre_movies/genre_movies_view.dart';
import '../ui/views/home/home_view.dart';
import '../ui/views/keyword_movies/keyword_movies_view.dart';
import '../ui/views/login/login_view.dart';
import '../ui/views/movie_details/movie_details_view.dart';
import '../ui/views/popular_movies/popular_movies_view.dart';
import '../ui/views/profile/profile_view.dart';
import '../ui/views/register/register_view.dart';
import '../ui/views/search/search_view.dart';
import '../ui/views/startup/startup_view.dart';
import '../ui/views/top_rated_movies/top_rated_movies_view.dart';
import '../ui/views/trending_movies/trending_movies_view.dart';

const String startupViewRoute = '/';
const String loginViewRoute = '/login';
const String registerViewRoute = '/register';
const String homeViewRoute = '/home';
const String movieDetailsViewRoute = '/movie-details';
const String searchViewRoute = '/search';
const String genreMoviesViewRoute = '/genre-movies';
const String keywordMoviesViewRoute = '/keyword-movies';
const String profileViewRoute = '/profile';
const String castDetailsViewRoute = '/cast-details';
const String favouritesViewRoute = '/favourites';
const String popularMoviesViewRoute = '/popular-movies';
const String topRatedMoviesViewRoute = '/top-rated-movies';
const String trendingMoviesViewRoute = '/trending-movies';

class StackedRouter {
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case startupViewRoute:
        return MaterialPageRoute<dynamic>(
            builder: (_) => const StartupView(), settings: settings);
      case loginViewRoute:
        return MaterialPageRoute<dynamic>(
            builder: (_) => const LoginView(), settings: settings);
      case registerViewRoute:
        return MaterialPageRoute<dynamic>(
            builder: (_) => const RegisterView(), settings: settings);
      case homeViewRoute:
        return MaterialPageRoute<dynamic>(
            builder: (_) => const HomeView(), settings: settings);
      case movieDetailsViewRoute:
        return MaterialPageRoute<dynamic>(
            builder: (_) => MovieDetailsView(id: settings.arguments as String),
            settings: settings);
      case searchViewRoute:
        return MaterialPageRoute<dynamic>(
            builder: (_) => const SearchView(), settings: settings);
      case genreMoviesViewRoute:
        final args = settings.arguments as GenreMoviesViewArguments;
        return MaterialPageRoute<dynamic>(
            builder: (_) => GenreMoviesView(
                genreId: args.genreId, genreName: args.genreName),
            settings: settings);
      case keywordMoviesViewRoute:
        final args = settings.arguments as KeywordMoviesViewArguments;
        return MaterialPageRoute<dynamic>(
            builder: (_) => KeywordMoviesView(
                keywordId: args.keywordId, genreName: args.genreName),
            settings: settings);
      case profileViewRoute:
        return MaterialPageRoute<dynamic>(
            builder: (_) => const ProfileView(), settings: settings);
      case castDetailsViewRoute:
        return MaterialPageRoute<dynamic>(
            builder: (_) => CastDetailsView(id: settings.arguments as String),
            settings: settings);
      case favouritesViewRoute:
        return MaterialPageRoute<dynamic>(
            builder: (_) => const FavouritesView(), settings: settings);
      case popularMoviesViewRoute:
        return MaterialPageRoute<dynamic>(
            builder: (_) => const PopularMoviesView(), settings: settings);
      case topRatedMoviesViewRoute:
        return MaterialPageRoute<dynamic>(
            builder: (_) => const TopRatedMoviesView(), settings: settings);
      case trendingMoviesViewRoute:
        return MaterialPageRoute<dynamic>(
            builder: (_) => const TrendingMoviesView(), settings: settings);
      default:
        return MaterialPageRoute<dynamic>(
            builder: (_) => const StartupView(), settings: settings);
    }
  }
}

class GenreMoviesViewArguments {
  final int genreId;
  final String genreName;
  const GenreMoviesViewArguments(
      {required this.genreId, required this.genreName});
}

class KeywordMoviesViewArguments {
  final int keywordId;
  final String genreName;
  const KeywordMoviesViewArguments(
      {required this.keywordId, required this.genreName});
}

extension NavigationServiceExtension on NavigationService {
  Future<dynamic>? navigateToStartupView() => navigateTo(startupViewRoute);
  Future<dynamic>? navigateToLoginView() => navigateTo(loginViewRoute);
  Future<dynamic>? navigateToRegisterView() => navigateTo(registerViewRoute);
  Future<dynamic>? navigateToHomeView() => navigateTo(homeViewRoute);
  Future<dynamic>? navigateToSearchView() => navigateTo(searchViewRoute);
  Future<dynamic>? navigateToProfileView() => navigateTo(profileViewRoute);
  Future<dynamic>? navigateToFavouritesView() =>
      navigateTo(favouritesViewRoute);
  Future<dynamic>? navigateToPopularMoviesView() =>
      navigateTo(popularMoviesViewRoute);
  Future<dynamic>? navigateToTopRatedMoviesView() =>
      navigateTo(topRatedMoviesViewRoute);
  Future<dynamic>? navigateToTrendingMoviesView() =>
      navigateTo(trendingMoviesViewRoute);
  Future<dynamic>? navigateToMovieDetailsView({required String id}) =>
      navigateTo(movieDetailsViewRoute, arguments: id);
  Future<dynamic>? navigateToCastDetailsView({required String id}) =>
      navigateTo(castDetailsViewRoute, arguments: id);
  Future<dynamic>? navigateToGenreMoviesView(
          {required int genreId, required String genreName}) =>
      navigateTo(genreMoviesViewRoute,
          arguments:
              GenreMoviesViewArguments(genreId: genreId, genreName: genreName));
  Future<dynamic>? navigateToKeywordMoviesView(
          {required int keywordId, required String genreName}) =>
      navigateTo(keywordMoviesViewRoute,
          arguments: KeywordMoviesViewArguments(
              keywordId: keywordId, genreName: genreName));
  Future<dynamic>? replaceWithLoginView() => replaceWith(loginViewRoute);
  Future<dynamic>? replaceWithHomeView() => replaceWith(homeViewRoute);
  Future<dynamic>? replaceWithStartupView() => replaceWith(startupViewRoute);
}
