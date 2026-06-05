import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../ui/widgets/movies_widget.dart';
import '../../../util/responsive.dart';
import 'favourites_viewmodel.dart';

class FavouritesView extends StackedView<FavouritesViewModel> {
  const FavouritesView({super.key});

  @override
  Widget builder(
      BuildContext context, FavouritesViewModel viewModel, Widget? child) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Favourites',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: viewModel.isBusy
          ? const Center(child: CircularProgressIndicator())
          : viewModel.films.isEmpty
              ? const Center(
                  child: Text(
                    'No favourites yet',
                    style: TextStyle(color: Colors.white54),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GridView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: Responsive.isDesktop(context)
                          ? 8
                          : Responsive.isTablet(context)
                              ? 7
                              : 3,
                      childAspectRatio: Responsive.isTablet(context)
                          ? 0.5
                          : Responsive.isDesktop(context)
                              ? 0.6
                              : 0.58,
                    ),
                    itemCount: viewModel.films.length,
                    itemBuilder: (_, index) {
                      final film = viewModel.films[index];
                      return Stack(
                        children: [
                          MoviesWidget(
                            title: film.title ?? 'No title',
                            posterPath:
                                'https://image.tmdb.org/t/p/w500${film.posterPath ?? ''}',
                            id: film.id ?? 0,
                            onTap: () =>
                                viewModel.navigateToMovieDetails(film.id ?? 0),
                          ),
                          Positioned.fill(
                            top: Responsive.isDesktop(context) ? 15 : 5,
                            right: Responsive.isDesktop(context) ? 20 : 1,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert,
                                    color: Colors.white),
                                onSelected: (value) {
                                  if (value == 'delete') {
                                    viewModel.deleteFilm(
                                        filmId: film.id.toString());
                                  }
                                },
                                itemBuilder: (_) => [
                                  const PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Text('Delete'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
    );
  }

  @override
  FavouritesViewModel viewModelBuilder(BuildContext context) =>
      FavouritesViewModel();

  @override
  void onViewModelReady(FavouritesViewModel viewModel) =>
      viewModel.loadFavourites();
}
