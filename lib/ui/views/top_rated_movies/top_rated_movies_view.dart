import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../widgets/paginated_movie_grid.dart';
import 'top_rated_movies_viewmodel.dart';

class TopRatedMoviesView extends StackedView<TopRatedMoviesViewModel> {
  const TopRatedMoviesView({super.key});

  @override
  Widget builder(BuildContext context, TopRatedMoviesViewModel viewModel, Widget? child) {
    final movies = viewModel.results?.results
        .map((r) => GridMovieItem(id: r.id, title: r.title ?? '', posterPath: r.posterPath ?? ''))
        .toList();
    return PaginatedMovieGrid(
      title: 'Top Rated',
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
  TopRatedMoviesViewModel viewModelBuilder(BuildContext context) => TopRatedMoviesViewModel();

  @override
  void onViewModelReady(TopRatedMoviesViewModel viewModel) => viewModel.loadMovies();
}
