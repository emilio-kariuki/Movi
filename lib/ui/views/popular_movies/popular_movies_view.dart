import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../widgets/paginated_movie_grid.dart';
import 'popular_movies_viewmodel.dart';

class PopularMoviesView extends StackedView<PopularMoviesViewModel> {
  const PopularMoviesView({super.key});

  @override
  Widget builder(
      BuildContext context, PopularMoviesViewModel viewModel, Widget? child) {
    final movies = viewModel.results?.results
        .map((r) => GridMovieItem(
            id: r.id, title: r.title ?? '', posterPath: r.posterPath ?? ''))
        .toList();
    return PaginatedMovieGrid(
      title: 'Popular',
      isBusy: viewModel.isBusy,
      hasError: viewModel.hasError,
      errorMessage: viewModel.modelError?.toString(),
      items: movies,
      currentPage: viewModel.currentPage,
      onPageChanged: (page) => viewModel.loadMovies(page: page),
      onMovieTap: viewModel.navigateToMovieDetails,
    );
  }

  @override
  PopularMoviesViewModel viewModelBuilder(BuildContext context) =>
      PopularMoviesViewModel();

  @override
  void onViewModelReady(PopularMoviesViewModel viewModel) =>
      viewModel.loadMovies();
}
