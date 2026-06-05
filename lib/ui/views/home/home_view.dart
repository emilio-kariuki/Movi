import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:stacked/stacked.dart';
import 'home_viewmodel.dart';

const _kBgTop = Color(0xFF030712);
const _kBgBottom = Color(0xFF0B1020);
const _kSurface = Color(0xFF131B2E);
const _kSurfaceSoft = Color(0xFF1A2440);
const _kAccent = Color(0xFF3B82F6);
const _kTextSoft = Color(0xFF94A3B8);

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  static final _placeholderHeroes = List.generate(
    4,
    (index) => _HeroItem(
      id: index,
      title: 'Loading featured movie',
      subtitle: 'Now streaming',
      posterPath: '',
    ),
  );

  static final _placeholderMovies = List.generate(
    10,
    (index) => _MovieItem(
      id: index,
      title: 'Loading movie title',
      posterPath: '',
      rating: 7.8,
    ),
  );

  static const _placeholderGenres = [
    'Action',
    'Adventure',
    'Drama',
    'Fantasy',
    'Thriller',
  ];

  @override
  Widget builder(BuildContext context, HomeViewModel viewModel, Widget? child) {
    final loading = viewModel.isBusy ||
        viewModel.trending == null ||
        viewModel.popular == null ||
        viewModel.topRated == null;

    final heroItems = viewModel.trending?.results
            .take(5)
            .map(
              (item) => _HeroItem(
                id: item.id,
                title: (item.title ?? item.name ?? '').isEmpty
                    ? 'Untitled movie'
                    : (item.title ?? item.name ?? ''),
                subtitle: 'Play trailer',
                posterPath: item.backdropPath?.isNotEmpty == true
                    ? item.backdropPath!
                    : (item.posterPath ?? ''),
              ),
            )
            .toList() ??
        _placeholderHeroes;

    final latestItems = viewModel.popular?.results
            .take(10)
            .map(
              (item) => _MovieItem(
                id: item.id,
                title: item.title ?? 'Untitled movie',
                posterPath: item.posterPath ?? '',
                rating: item.voteAverage ?? 0,
              ),
            )
            .toList() ??
        _placeholderMovies;

    final topRatedItems = viewModel.topRated?.results
            .take(10)
            .map(
              (item) => _MovieItem(
                id: item.id,
                title: item.title ?? 'Untitled movie',
                posterPath: item.posterPath ?? '',
                rating: item.voteAverage ?? 0,
              ),
            )
            .toList() ??
        _placeholderMovies;

    final genres = viewModel.genres?.genres.map((g) => g.name).toList() ??
        _placeholderGenres;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: _kBgTop,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _kBgTop,
                _kBgBottom,
                Colors.black.withValues(alpha: 0.96),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -120,
                right: -80,
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        _kAccent.withValues(alpha: 0.28),
                        _kAccent.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -180,
                left: -140,
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF1D4ED8).withValues(alpha: 0.22),
                        const Color(0xFF1D4ED8).withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
              SafeArea(
                bottom: false,
                child: RefreshIndicator(
                  onRefresh: viewModel.refresh,
                  color: _kAccent,
                  backgroundColor: _kSurface,
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                          child: Skeletonizer(
                            enabled: loading,
                            effect: const ShimmerEffect(
                              baseColor: Color(0xFF1A2339),
                              highlightColor: Color(0xFF293757),
                              duration: Duration(milliseconds: 1250),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _Header(
                                  onSearch: viewModel.navigateToSearch,
                                  onProfile: viewModel.navigateToProfile,
                                ),
                                const SizedBox(height: 18),
                                _HeroRail(
                                  items: heroItems,
                                  onTap: (id) {
                                    if (!loading) {
                                      viewModel.navigateToMovieDetails(id);
                                    }
                                  },
                                ),
                                const SizedBox(height: 10),
                                _IndicatorRow(count: heroItems.length),
                                const SizedBox(height: 18),
                                _MovieSection(
                                  title: 'Latest movies',
                                  items: latestItems,
                                  onViewAll: viewModel.navigateToPopular,
                                  onMovieTap: (id) {
                                    if (!loading) {
                                      viewModel.navigateToMovieDetails(id);
                                    }
                                  },
                                ),
                                const SizedBox(height: 18),
                                _MovieSection(
                                  title: 'Top rated',
                                  items: topRatedItems,
                                  onViewAll: viewModel.navigateToTopRated,
                                  onMovieTap: (id) {
                                    if (!loading) {
                                      viewModel.navigateToMovieDetails(id);
                                    }
                                  },
                                ),
                                const SizedBox(height: 18),
                                _GenreRail(
                                  genres: genres,
                                  onTap: (name) {
                                    if (loading || viewModel.genres == null) {
                                      return;
                                    }
                                    final matches = viewModel.genres!.genres
                                        .where((g) => g.name == name)
                                        .toList();
                                    if (matches.isEmpty) {
                                      return;
                                    }
                                    final genre = matches.first;
                                    viewModel.navigateToGenre(
                                      genre.id,
                                      genre.name,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (viewModel.hasError)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            child: Text(
                              viewModel.modelError.toString(),
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFFFCA5A5),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();

  @override
  void onViewModelReady(HomeViewModel viewModel) => viewModel.loadHome();
}

class _Header extends StatelessWidget {
  final VoidCallback onSearch;
  final VoidCallback onProfile;

  const _Header({required this.onSearch, required this.onProfile});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back,',
                style: GoogleFonts.plusJakartaSans(
                  color: _kTextSoft,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Yacob Krisna',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
        _HeaderIcon(
          icon: Icons.notifications_none_rounded,
          onTap: onProfile,
        ),
        const SizedBox(width: 10),
        _HeaderIcon(
          icon: Icons.search_rounded,
          onTap: onSearch,
        ),
      ],
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Ink(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: _kSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF2B3854), width: 1),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _HeroRail extends StatelessWidget {
  final List<_HeroItem> items;
  final ValueChanged<int> onTap;

  const _HeroRail({required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.84;
    return SizedBox(
      height: 185,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (_, index) {
          final item = items[index];
          return GestureDetector(
            onTap: () => onTap(item.id),
            child: Container(
              width: width,
              margin:
                  EdgeInsets.only(right: index == items.length - 1 ? 0 : 14),
              decoration: BoxDecoration(
                color: _kSurface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: const Color(0xFF2A3755),
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (item.posterPath.isNotEmpty)
                      CachedNetworkImage(
                        imageUrl:
                            'https://image.tmdb.org/t/p/w780${item.posterPath}',
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(color: _kSurfaceSoft),
                        errorWidget: (_, __, ___) =>
                            Container(color: _kSurfaceSoft),
                      )
                    else
                      Container(color: _kSurfaceSoft),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.black.withValues(alpha: 0.45),
                            Colors.black.withValues(alpha: 0.15),
                            Colors.black.withValues(alpha: 0.65),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              'Live now',
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              height: 1.02,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white.withValues(alpha: 0.88),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 34,
                            width: 110,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: _kAccent,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Text(
                              'Play now',
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _IndicatorRow extends StatelessWidget {
  final int count;

  const _IndicatorRow({required this.count});

  @override
  Widget build(BuildContext context) {
    final showCount = count > 4 ? 4 : count;
    return Row(
      children: List.generate(
        showCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.only(right: 5),
          width: index == 0 ? 18 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: index == 0 ? _kAccent : const Color(0xFF334155),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class _MovieSection extends StatelessWidget {
  final String title;
  final List<_MovieItem> items;
  final VoidCallback onViewAll;
  final ValueChanged<int> onMovieTap;

  const _MovieSection({
    required this.title,
    required this.items,
    required this.onViewAll,
    required this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
              onPressed: onViewAll,
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'See all',
                style: GoogleFonts.plusJakartaSans(
                  color: _kAccent,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 226,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (_, index) {
              final movie = items[index];
              return GestureDetector(
                onTap: () => onMovieTap(movie.id),
                child: Container(
                  width: 126,
                  margin: EdgeInsets.only(
                      right: index == items.length - 1 ? 0 : 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              if (movie.posterPath.isNotEmpty)
                                CachedNetworkImage(
                                  imageUrl:
                                      'https://image.tmdb.org/t/p/w300${movie.posterPath}',
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) =>
                                      Container(color: _kSurfaceSoft),
                                  errorWidget: (_, __, ___) =>
                                      Container(color: _kSurfaceSoft),
                                )
                              else
                                Container(color: _kSurfaceSoft),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.72),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.star_rounded,
                                        color: Color(0xFFFACC15),
                                        size: 10,
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        movie.rating.toStringAsFixed(1),
                                        style: GoogleFonts.plusJakartaSans(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
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
                      const SizedBox(height: 8),
                      Text(
                        movie.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(movie.rating * 12).clamp(82, 190).round()}m',
                        style: GoogleFonts.plusJakartaSans(
                          color: _kTextSoft,
                          fontSize: 12,
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
      ],
    );
  }
}

class _GenreRail extends StatelessWidget {
  final List<String> genres;
  final ValueChanged<String> onTap;

  const _GenreRail({required this.genres, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Genres',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: genres.length,
            itemBuilder: (_, index) {
              final genre = genres[index];
              return GestureDetector(
                onTap: () => onTap(genre),
                child: Container(
                  margin: EdgeInsets.only(
                      right: index == genres.length - 1 ? 0 : 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                  decoration: BoxDecoration(
                    color: _kSurface,
                    borderRadius: BorderRadius.circular(24),
                    border:
                        Border.all(color: const Color(0xFF2A3755), width: 1),
                  ),
                  child: Text(
                    genre,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _HeroItem {
  final int id;
  final String title;
  final String subtitle;
  final String posterPath;

  const _HeroItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.posterPath,
  });
}

class _MovieItem {
  final int id;
  final String title;
  final String posterPath;
  final double rating;

  const _MovieItem({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.rating,
  });
}
