import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../widgets/paginated_movie_grid.dart';
import 'keyword_movies_viewmodel.dart';

class KeywordMoviesView extends StackedView<KeywordMoviesViewModel> {
  final int keywordId;
  final String genreName;

  const KeywordMoviesView(
      {super.key, required this.keywordId, required this.genreName});

  @override
  Widget builder(
      BuildContext context, KeywordMoviesViewModel viewModel, Widget? child) {
    final movies = viewModel.results?.results
        .map((r) => GridMovieItem(
            id: r.id, title: r.title ?? '', posterPath: r.posterPath ?? ''))
        .toList();
    return PaginatedMovieGrid(
      title: genreName,
      isBusy: viewModel.isBusy,
      hasError: viewModel.hasError,
      errorMessage: viewModel.modelError?.toString(),
      items: movies,
      currentPage: viewModel.currentPage,
      onPageChanged: (page) =>
          viewModel.loadMovies(keywordId: keywordId, page: page),
      onMovieTap: viewModel.navigateToMovieDetails,
    );
  }

  @override
  KeywordMoviesViewModel viewModelBuilder(BuildContext context) =>
      KeywordMoviesViewModel();

  @override
  void onViewModelReady(KeywordMoviesViewModel viewModel) =>
      viewModel.loadMovies(keywordId: keywordId);
}
