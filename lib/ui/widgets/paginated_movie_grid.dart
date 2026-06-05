import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pagination_flutter/pagination.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../util/responsive.dart';
import 'movies_widget.dart';

const _kBg = Color(0xFF0D0D1A);
const _kCard = Color(0xFF1A1A2E);
const _kAccent = Color(0xFF1E88E5);

class PaginatedMovieGrid extends StatelessWidget {
  final String title;
  final bool isBusy;
  final bool hasError;
  final String? errorMessage;
  final List<GridMovieItem>? items;
  final int currentPage;
  final void Function(int page) onPageChanged;
  final void Function(int id) onMovieTap;

  const PaginatedMovieGrid({
    super.key,
    required this.title,
    required this.isBusy,
    required this.hasError,
    this.errorMessage,
    this.items,
    required this.currentPage,
    required this.onPageChanged,
    required this.onMovieTap,
  });

  static final _skeletonItems = List.generate(
    12,
    (i) => GridMovieItem(id: i, title: 'Loading Title Here', posterPath: ''),
  );

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = Responsive.isDesktop(context)
        ? 6
        : Responsive.isTablet(context)
            ? 4
            : 3;

    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: _kBg,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _kCard,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 16),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: _kBg,
        child: Pagination(
          numOfPages: 100,
          selectedPage: currentPage,
          pagesVisible: 3,
          onPageChanged: onPageChanged,
          nextIcon:
              const Icon(Icons.arrow_forward_ios, color: _kAccent, size: 14),
          previousIcon:
              const Icon(Icons.arrow_back_ios, color: _kAccent, size: 14),
          activeTextStyle: GoogleFonts.poppins(
              color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
          activeBtnStyle: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(_kAccent),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
          ),
          inactiveBtnStyle: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(_kCard),
            shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
          ),
          inactiveTextStyle: GoogleFonts.poppins(
              color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ),
      body: SafeArea(
        child: hasError
            ? Center(
                child: Text(errorMessage ?? 'Something went wrong',
                    style: GoogleFonts.poppins(color: Colors.white70)),
              )
            : isBusy
                ? Skeletonizer(
                    enabled: true,
                    effect: const ShimmerEffect(
                      baseColor: Color(0xFF1A2339),
                      highlightColor: Color(0xFF293757),
                      duration: Duration(milliseconds: 1250),
                    ),
                    child: GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 0.6,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: _skeletonItems.length,
                      itemBuilder: (_, __) => Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A3E),
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: 0.6,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: (items ?? []).length,
                    itemBuilder: (_, index) {
                      final movie = (items ?? [])[index];
                      return MoviesWidget(
                        title: movie.title,
                        posterPath: movie.posterPath.isEmpty
                            ? ''
                            : 'https://image.tmdb.org/t/p/w300${movie.posterPath}',
                        id: movie.id,
                        onTap: () => onMovieTap(movie.id),
                      );
                    },
                  ),
      ),
    );
  }
}

class GridMovieItem {
  final int id;
  final String title;
  final String posterPath;

  const GridMovieItem({
    required this.id,
    required this.title,
    required this.posterPath,
  });
}
