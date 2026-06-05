import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../widgets/paginated_movie_grid.dart';
import 'genre_movies_viewmodel.dart';

class GenreMoviesView extends StackedView<GenreMoviesViewModel> {
  final int genreId;
  final String genreName;

  const GenreMoviesView(
      {super.key, required this.genreId, required this.genreName});

  @override
  Widget builder(
      BuildContext context, GenreMoviesViewModel viewModel, Widget? child) {
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
          viewModel.loadMovies(genreId: genreId, page: page),
      onMovieTap: viewModel.navigateToMovieDetails,
    );
  }

  @override
  GenreMoviesViewModel viewModelBuilder(BuildContext context) =>
      GenreMoviesViewModel();

  @override
  void onViewModelReady(GenreMoviesViewModel viewModel) =>
      viewModel.loadMovies(genreId: genreId);
}
