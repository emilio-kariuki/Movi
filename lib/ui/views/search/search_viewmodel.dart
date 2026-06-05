import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../app/app.locator.dart';
import '../../../app/app.router.dart';
import '../../../models/search_movie_model.dart';
import '../../../services/movie_service.dart';

class SearchViewModel extends ReactiveViewModel {
  final _movies = locator<MovieService>();
  final _navigation = locator<NavigationService>();
  final queryController = TextEditingController();

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_movies];

  SearchModel? get results => _movies.searchResults;
  int currentPage = 1;
  String _query = 'a';

  Future<void> search({required String query, int page = 1}) async {
    _query = query.isEmpty ? 'a' : query;
    currentPage = page;
    setBusy(true);
    try {
      await _movies.fetchSearchResults(title: _query, page: page);
    } catch (e) {
      setError(e.toString());
    } finally {
      setBusy(false);
    }
  }

  Future<void> changePage(int page) => search(query: _query, page: page);

  void navigateToMovieDetails(int id) =>
      _navigation.navigateToMovieDetailsView(id: id.toString());

  @override
  void dispose() {
    queryController.dispose();
    super.dispose();
  }
}
