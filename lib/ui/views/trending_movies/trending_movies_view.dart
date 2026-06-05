import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../widgets/paginated_movie_grid.dart';
import 'trending_movies_viewmodel.dart';

class TrendingMoviesView extends StackedView<TrendingMoviesViewModel> {
  const TrendingMoviesView({super.key});

  @override
  Widget builder(
      BuildContext context, TrendingMoviesViewModel viewModel, Widget? child) {
    final movies = viewModel.results?.results
        .map((r) => GridMovieItem(
              id: r.id,
              title: r.title ?? r.name ?? '',
              posterPath: r.posterPath ?? r.backdropPath ?? '',
            ))
        .toList();
    return PaginatedMovieGrid(
      title: 'Trending',
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
  TrendingMoviesViewModel viewModelBuilder(BuildContext context) =>
      TrendingMoviesViewModel();

  @override
  void onViewModelReady(TrendingMoviesViewModel viewModel) =>
      viewModel.loadMovies();
}
