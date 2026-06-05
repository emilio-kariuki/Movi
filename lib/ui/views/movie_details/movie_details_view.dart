import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:stacked/stacked.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart' as ytmobile;
import '../../../models/movie_trailer.dart';
import '../../widgets/movies_widget.dart';
import 'movie_details_viewmodel.dart';

const _kBg = Color(0xFF020617);
const _kPanel = Color(0xFF0B1220);
const _kSurface = Color(0xFF121A2B);
const _kAccent = Color(0xFF3B82F6);
const _kTextSoft = Color(0xFF94A3B8);

class MovieDetailsView extends StackedView<MovieDetailsViewModel> {
  final String id;

  const MovieDetailsView({super.key, required this.id});

  static final _placeholderCast = List.generate(
    8,
    (index) => _CastItem(
      id: index,
      name: 'Actor name',
      role: 'Character',
      imagePath: '',
    ),
  );

  static final _placeholderSimilar = List.generate(
    8,
    (index) => _SimilarMovie(
      id: index,
      title: 'Loading movie title',
      posterPath: '',
      voteAverage: 7.8,
    ),
  );

  @override
  Widget builder(
    BuildContext context,
    MovieDetailsViewModel viewModel,
    Widget? child,
  ) {
    final movie = viewModel.movieDetails;
    final isLoading = viewModel.isBusy || movie == null;

    if (viewModel.hasError && movie == null) {
      return Scaffold(
        backgroundColor: _kBg,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          ),
        ),
        body: Center(
          child: Text(
            viewModel.modelError?.toString() ?? 'Unable to load details',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    final backdropPath = movie?.backdropPath?.isNotEmpty == true
        ? movie!.backdropPath!
        : (movie?.posterPath ?? '');

    final title = movie?.title.isNotEmpty == true
        ? movie!.title
        : 'Avatar: The Way of Water';

    final overview = movie?.overview.isNotEmpty == true
        ? movie!.overview
        : 'Jake Sully and Neytiri have formed a family and are doing everything to stay together. However, they must leave their home and explore the regions of Pandora.';

    final runtime = _formatTime(movie?.runtime ?? 192);
    final year = movie?.releaseDate.year.toString() ?? '2022';
    final voteAverage = movie?.voteAverage ?? 8.3;
    final genres = movie?.genres.map((genre) => genre.name).toList() ??
        ['Sci-Fi', 'Adventure', 'Action'];

    final castItems = viewModel.casts?.cast
            .take(12)
            .map(
              (cast) => _CastItem(
                id: cast.id,
                name: cast.name,
                role: cast.character ?? cast.knownForDepartment,
                imagePath: cast.profilePath ?? '',
              ),
            )
            .toList() ??
        _placeholderCast;

    final similarItems = viewModel.similar?.results
            .take(12)
            .map(
              (movie) => _SimilarMovie(
                id: movie.id,
                title: movie.title ?? 'Untitled',
                posterPath: movie.posterPath ?? '',
                voteAverage: movie.voteAverage ?? 0,
              ),
            )
            .toList() ??
        _placeholderSimilar;

    final trailerKey = _extractYoutubeKey(viewModel.trailer);

    return Scaffold(
      backgroundColor: _kBg,
      body: Skeletonizer(
        enabled: isLoading,
        effect: const ShimmerEffect(
          baseColor: Color(0xFF1A2339),
          highlightColor: Color(0xFF293757),
          duration: Duration(milliseconds: 1250),
        ),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 372,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (viewModel.isTrailerPlaying &&
                        viewModel.trailerController != null)
                      Container(
                        color: Colors.black,
                        child: ytmobile.YoutubePlayer(
                          controller: viewModel.trailerController!,
                          showVideoProgressIndicator: true,
                        ),
                      )
                    else ...[
                      if (backdropPath.isNotEmpty)
                        CachedNetworkImage(
                          imageUrl:
                              'https://image.tmdb.org/t/p/w780$backdropPath',
                          fit: BoxFit.cover,
                          placeholder: (_, __) =>
                              Container(color: const Color(0xFF1A2440)),
                          errorWidget: (_, __, ___) =>
                              Container(color: const Color(0xFF1A2440)),
                        )
                      else
                        Container(color: const Color(0xFF1A2440)),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.2),
                              Colors.black.withValues(alpha: 0.25),
                              _kBg.withValues(alpha: 0.95),
                            ],
                          ),
                        ),
                      ),
                    ],
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _TopIcon(
                              icon: Icons.arrow_back_rounded,
                              onTap: () => Navigator.of(context).pop(),
                            ),
                            _TopIcon(
                              icon: viewModel.isTrailerPlaying
                                  ? Icons.close_rounded
                                  : Icons.ios_share_rounded,
                              onTap: viewModel.isTrailerPlaying
                                  ? viewModel.stopInlineTrailer
                                  : () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!viewModel.isTrailerPlaying)
                      Center(
                        child: GestureDetector(
                          onTap: trailerKey == null
                              ? null
                              : () => viewModel.playTrailerInline(trailerKey),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 72,
                                height: 72,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black.withValues(alpha: 0.35),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 42,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Play trailer',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Transform.translate(
                offset: const Offset(0, -34),
                child: Container(
                  decoration: const BoxDecoration(
                    color: _kPanel,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  padding: const EdgeInsets.fromLTRB(18, 20, 18, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 34,
                                fontWeight: FontWeight.w700,
                                height: 1.04,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            borderRadius: BorderRadius.circular(15),
                            onTap: isLoading ? null : viewModel.toggleFavourite,
                            child: Ink(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: _kSurface,
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: const Color(0xFF2A3550),
                                ),
                              ),
                              child: Icon(
                                viewModel.isFavourite
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: const Color(0xFFF43F5E),
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          const _MetaChip(text: '18+'),
                          _MetaChip(
                              text: '${voteAverage.toStringAsFixed(1)} ★'),
                          _MetaChip(text: runtime),
                          _MetaChip(
                              text: genres.isEmpty ? 'Drama' : genres.first),
                          _MetaChip(text: year),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Container(
                            width: 86,
                            height: 42,
                            decoration: BoxDecoration(
                              color: _kSurface,
                              borderRadius: BorderRadius.circular(14),
                              border:
                                  Border.all(color: const Color(0xFF2A3550)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.download_rounded,
                                  color: Colors.white,
                                  size: 17,
                                ),
                                const SizedBox(height: 1),
                                Text(
                                  'Download',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: const Color(0xFFCBD5E1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              height: 42,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF3B82F6),
                                    Color(0xFF2563EB)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: _kAccent.withValues(alpha: 0.4),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: trailerKey == null
                                    ? null
                                    : () =>
                                        viewModel.playTrailerInline(trailerKey),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: Text(
                                  'Play now',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(
                        overview,
                        style: GoogleFonts.plusJakartaSans(
                          color: _kTextSoft,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.55,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _SectionTitle(
                        title: 'Cast',
                        trailing: 'See all',
                        onTap: () {},
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 126,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: castItems.length,
                          itemBuilder: (_, index) {
                            final cast = castItems[index];
                            return GestureDetector(
                              onTap: isLoading
                                  ? null
                                  : () => viewModel.navigateToCast(cast.id),
                              child: Container(
                                width: 95,
                                margin: EdgeInsets.only(
                                  right: index == castItems.length - 1 ? 0 : 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: SizedBox(
                                        width: 95,
                                        height: 78,
                                        child: cast.imagePath.isNotEmpty
                                            ? CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w300${cast.imagePath}',
                                                fit: BoxFit.cover,
                                                placeholder: (_, __) =>
                                                    Container(
                                                        color: const Color(
                                                            0xFF1A2440)),
                                                errorWidget: (_, __, ___) =>
                                                    Container(
                                                        color: const Color(
                                                            0xFF1A2440)),
                                              )
                                            : Container(
                                                color: const Color(0xFF1A2440),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                      cast.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.plusJakartaSans(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      cast.role,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.plusJakartaSans(
                                        color: _kTextSoft,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 24),
                      _SectionTitle(
                        title: 'Similar movies',
                        trailing: 'See all',
                        onTap: () {},
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 212,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: similarItems.length,
                          itemBuilder: (_, index) {
                            final item = similarItems[index];
                            return MoviesWidget(
                              title: item.title,
                              posterPath: item.posterPath.isEmpty
                                  ? ''
                                  : 'https://image.tmdb.org/t/p/w300${item.posterPath}',
                              voteAverage: item.voteAverage,
                              id: item.id,
                              onTap: isLoading
                                  ? () {}
                                  : () =>
                                      viewModel.navigateToMovieDetails(item.id),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 18),
                      if ((viewModel.keywords?.keywords.isNotEmpty ?? false) ||
                          isLoading)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: (viewModel.keywords?.keywords
                                      .map((k) => k.name)
                                      .toList() ??
                                  ['Fantasy', 'Epic', 'Alien world', 'Ocean'])
                              .take(8)
                              .map(
                                (keyword) => GestureDetector(
                                  onTap: isLoading
                                      ? null
                                      : () {
                                          final data = viewModel.keywords;
                                          if (data == null) {
                                            return;
                                          }
                                          final found = data.keywords
                                              .where((k) => k.name == keyword)
                                              .toList();
                                          if (found.isEmpty) {
                                            return;
                                          }
                                          final target = found.first;
                                          viewModel.navigateToKeyword(
                                            target.id,
                                            target.name,
                                          );
                                        },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 7,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _kSurface,
                                      borderRadius: BorderRadius.circular(22),
                                      border: Border.all(
                                        color: const Color(0xFF2A3550),
                                      ),
                                    ),
                                    child: Text(
                                      keyword,
                                      style: GoogleFonts.plusJakartaSans(
                                        color: const Color(0xFFCBD5E1),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int minutes) {
    final safeMinutes = minutes <= 0 ? 120 : minutes;
    final hours = safeMinutes ~/ 60;
    final mins = safeMinutes % 60;
    return '${hours}h ${mins.toString().padLeft(2, '0')}m';
  }

  String? _extractYoutubeKey(Trailer? trailer) {
    final results = trailer?.results;
    if (results == null || results.isEmpty) {
      return null;
    }
    for (final result in results) {
      final site = siteValues.reverse[result.site];
      if (site == 'YouTube' && result.key != null && result.key!.isNotEmpty) {
        return result.key;
      }
    }
    return results.first.key;
  }

  @override
  MovieDetailsViewModel viewModelBuilder(BuildContext context) =>
      MovieDetailsViewModel();

  @override
  void onViewModelReady(MovieDetailsViewModel viewModel) =>
      viewModel.loadDetails(id: int.parse(id));
}

class _TopIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _TopIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Ink(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String text;

  const _MetaChip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF2A3550)),
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          color: const Color(0xFFE2E8F0),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String trailing;
  final VoidCallback onTap;

  const _SectionTitle({
    required this.title,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            trailing,
            style: GoogleFonts.plusJakartaSans(
              color: _kAccent,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _CastItem {
  final int id;
  final String name;
  final String role;
  final String imagePath;

  const _CastItem({
    required this.id,
    required this.name,
    required this.role,
    required this.imagePath,
  });
}

class _SimilarMovie {
  final int id;
  final String title;
  final String posterPath;
  final double voteAverage;

  const _SimilarMovie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.voteAverage,
  });
}
