import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../models/movie_model.dart';
import '../../../services/movie_service.dart';

class KeywordMoviesViewModel extends ReactiveViewModel {
  final _movies = locator<MovieService>();
  final _navigation = locator<NavigationService>();

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_movies];

  MovieModel? get results => _movies.keywordMovies;
  int currentPage = 1;

  Future<void> loadMovies({required int keywordId, int page = 1}) async {
    currentPage = page;
    setBusy(true);
    try {
      await _movies.fetchKeywordMovies(id: keywordId, page: page);
    } catch (e) {
      setError(e.toString());
    } finally {
      setBusy(false);
    }
  }

  void navigateToMovieDetails(int id) =>
      _navigation.navigateToMovieDetailsView(id: id.toString());
}
