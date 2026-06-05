import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../models/cast_model.dart';
import '../../../models/user_films_model.dart';
import '../../../services/movie_service.dart';

class CastDetailsViewModel extends ReactiveViewModel {
  final _movies = locator<MovieService>();
  final _navigation = locator<NavigationService>();

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_movies];

  CastModel? get castProfile => _movies.currentCast;
  UserFilms? get filmography => _movies.currentCastFilms;

  Future<void> loadCast({required int id}) async {
    setBusy(true);
    try {
      await _movies.fetchCastDetails(id: id);
    } catch (e) {
      setError(e.toString());
    } finally {
      setBusy(false);
    }
  }

  void navigateToMovieDetails(int id) =>
      _navigation.navigateToMovieDetailsView(id: id.toString());
}
