import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../util/responsive.dart';
import 'cast_details_viewmodel.dart';

class CastDetailsView extends StackedView<CastDetailsViewModel> {
  final String id;

  const CastDetailsView({super.key, required this.id});

  @override
  Widget builder(
      BuildContext context, CastDetailsViewModel viewModel, Widget? child) {
    if (viewModel.isBusy) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.5),
            child: const CircularProgressIndicator(strokeWidth: 3),
          ),
        ),
      );
    }

    final profile = viewModel.castProfile;
    final films = viewModel.filmography;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CachedNetworkImage(
                    height: Responsive.isDesktop(context)
                        ? MediaQuery.of(context).size.height * 0.5
                        : MediaQuery.of(context).size.height * 0.25,
                    width: double.infinity,
                    imageUrl:
                        'https://image.tmdb.org/t/p/w500${profile?.profilePath ?? ''}',
                    fit: BoxFit.cover,
                    placeholder: (_, __) => const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      height: 200,
                      color: Colors.grey[900],
                      child: const Icon(Icons.person,
                          color: Colors.white54, size: 80),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile?.name ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (profile != null) ...[
                      Text(
                        'Born: ${profile.birthday}',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      if (profile.biography.isNotEmpty)
                        Text(
                          profile.biography,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 14),
                        ),
                    ],
                    const SizedBox(height: 20),
                    if (films != null && films.cast.isNotEmpty) ...[
                      const Text(
                        'Movies',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: Responsive.isDesktop(context)
                              ? 8
                              : Responsive.isTablet(context)
                                  ? 5
                                  : 3,
                          childAspectRatio: 0.58,
                        ),
                        itemCount: films.cast.length,
                        itemBuilder: (_, index) {
                          final film = films.cast[index];
                          return GestureDetector(
                            onTap: () =>
                                viewModel.navigateToMovieDetails(film.id),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      height: 110,
                                      imageUrl:
                                          'https://image.tmdb.org/t/p/w500${film.posterPath ?? ''}',
                                      fit: BoxFit.cover,
                                      errorWidget: (_, __, ___) => Container(
                                        height: 110,
                                        color: Colors.grey[800],
                                        child: const Icon(Icons.movie,
                                            color: Colors.white54),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    film.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  CastDetailsViewModel viewModelBuilder(BuildContext context) =>
      CastDetailsViewModel();

  @override
  void onViewModelReady(CastDetailsViewModel viewModel) =>
      viewModel.loadCast(id: int.parse(id));
}
