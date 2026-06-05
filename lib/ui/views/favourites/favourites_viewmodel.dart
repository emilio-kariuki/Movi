import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../models/user_movies.dart';
import '../../../services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class FavouritesViewModel extends ReactiveViewModel {
  final _firebaseService = locator<FirebaseService>();
  final _navigation = locator<NavigationService>();

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_firebaseService];

  List<UserMovies> get films => _firebaseService.userFilms;

  Future<void> loadFavourites() async {
    setBusy(true);
    try {
      final uid = fb.FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        await _firebaseService.loadUserFilms(id: uid);
      }
    } catch (e) {
      setError(e.toString());
    } finally {
      setBusy(false);
    }
  }

  Future<void> deleteFilm({required String filmId}) async {
    await _firebaseService.deleteUserFilm(filmId: filmId);
  }

  void navigateToMovieDetails(int id) =>
      _navigation.navigateToMovieDetailsView(id: id.toString());
}
