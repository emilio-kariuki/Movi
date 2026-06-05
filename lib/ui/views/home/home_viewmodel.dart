import 'dart:math';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../models/genres_model.dart';
import '../../../models/movie_model.dart';
import '../../../models/trending_model.dart';
import '../../../services/movie_service.dart';

class HomeViewModel extends ReactiveViewModel {
  final _movies = locator<MovieService>();
  final _navigation = locator<NavigationService>();

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_movies];

  MovieModel? get popular => _movies.popular;
  Trending? get trending => _movies.trending;
  MovieModel? get topRated => _movies.topRated;
  Genres? get genres => _movies.genres;

  Future<void> loadHome() async {
    setBusy(true);
    try {
      final page = Random().nextInt(300) + 1;
      await _movies.fetchHomeData(page: page);
    } catch (e) {
      setError(e.toString());
    } finally {
      setBusy(false);
    }
  }

  Future<void> refresh() => loadHome();

  void navigateToMovieDetails(int id) =>
      _navigation.navigateToMovieDetailsView(id: id.toString());

  void navigateToSearch() => _navigation.navigateToSearchView();

  void navigateToPopular() => _navigation.navigateToPopularMoviesView();

  void navigateToTopRated() => _navigation.navigateToTopRatedMoviesView();

  void navigateToTrending() => _navigation.navigateToTrendingMoviesView();

  void navigateToGenre(int genreId, String genreName) => _navigation
      .navigateToGenreMoviesView(genreId: genreId, genreName: genreName);

  void navigateToProfile() => _navigation.navigateToProfileView();
}
