import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart' as ytmobile;
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../models/keywords_model.dart';
import '../../../models/movie_casts_model.dart';
import '../../../models/movie_details_model.dart';
import '../../../models/movie_model.dart';
import '../../../models/movie_trailer.dart';
import '../../../models/review_model.dart';
import '../../../models/user_movies.dart';
import '../../../services/firebase_service.dart';
import '../../../services/movie_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class MovieDetailsViewModel extends ReactiveViewModel {
  final _movies = locator<MovieService>();
  final _firebaseService = locator<FirebaseService>();
  final _navigation = locator<NavigationService>();

  @override
  List<ReactiveServiceMixin> get reactiveServices =>
      [_movies, _firebaseService];

  int? _currentId;
  bool _isTrailerPlaying = false;
  String? _currentTrailerKey;
  ytmobile.YoutubePlayerController? _trailerController;

  Movie? get movieDetails => _movies.currentMovieDetails;
  Cast? get casts => _movies.currentMovieCasts;
  MovieModel? get similar => _movies.currentSimilar;
  Trailer? get trailer => _movies.currentTrailer;
  Keywords? get keywords => _movies.currentKeywords;
  Review? get reviews => _movies.currentReviews;
  bool get isFavourite =>
      _currentId != null && _firebaseService.isFilmFavourited(_currentId!);
  bool get isTrailerPlaying => _isTrailerPlaying;
  ytmobile.YoutubePlayerController? get trailerController => _trailerController;

  Future<void> loadDetails({required int id}) async {
    _currentId = id;
    _resetTrailer();
    setBusy(true);
    try {
      final uid = fb.FirebaseAuth.instance.currentUser?.uid;
      await Future.wait([
        _movies.fetchMovieDetails(id: id),
        if (uid != null) _firebaseService.loadUserFilms(id: uid),
      ]);
    } catch (e) {
      setError(e.toString());
    } finally {
      setBusy(false);
    }
  }

  Future<void> toggleFavourite() async {
    if (movieDetails == null || _currentId == null) return;
    final uid = fb.FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    if (isFavourite) {
      await _firebaseService.deleteUserFilm(filmId: _currentId.toString());
    } else {
      await _firebaseService.addUserFilm(
        movie: UserMovies(
          id: movieDetails!.id,
          title: movieDetails!.title,
          posterPath: movieDetails!.posterPath,
          belongsTo: uid,
        ),
      );
    }
  }

  void playTrailerInline(String trailerKey) {
    if (trailerKey.isEmpty) {
      return;
    }

    if (_currentTrailerKey != trailerKey) {
      _trailerController?.dispose();
      _trailerController = ytmobile.YoutubePlayerController(
        initialVideoId: trailerKey,
        flags: const ytmobile.YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );
      _currentTrailerKey = trailerKey;
    }

    _isTrailerPlaying = true;
    rebuildUi();
  }

  void stopInlineTrailer() {
    if (!_isTrailerPlaying) {
      return;
    }
    _isTrailerPlaying = false;
    rebuildUi();
  }

  void _resetTrailer() {
    _isTrailerPlaying = false;
    _currentTrailerKey = null;
    _trailerController?.dispose();
    _trailerController = null;
  }

  void navigateToMovieDetails(int id) =>
      _navigation.navigateToMovieDetailsView(id: id.toString());

  void navigateToGenre(int genreId, String genreName) => _navigation
      .navigateToGenreMoviesView(genreId: genreId, genreName: genreName);

  void navigateToKeyword(int keywordId, String keywordName) =>
      _navigation.navigateToKeywordMoviesView(
          keywordId: keywordId, genreName: keywordName);

  void navigateToCast(int castId) =>
      _navigation.navigateToCastDetailsView(id: castId.toString());

  @override
  void dispose() {
    _trailerController?.dispose();
    super.dispose();
  }
}
