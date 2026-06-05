import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pagination_flutter/pagination.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:stacked/stacked.dart';
import '../../../util/responsive.dart';
import '../../widgets/movies_widget.dart';
import 'search_viewmodel.dart';

const _kBg = Color(0xFF0D0D1A);
const _kCard = Color(0xFF1A1A2E);
const _kAccent = Color(0xFF1E88E5);

class SearchView extends StackedView<SearchViewModel> {
  const SearchView({super.key});

  @override
  Widget builder(
      BuildContext context, SearchViewModel viewModel, Widget? child) {
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
                color: _kCard, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 16),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Search',
          style: GoogleFonts.poppins(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      bottomNavigationBar: Container(
        color: _kBg,
        child: Pagination(
          numOfPages: 100,
          selectedPage: viewModel.currentPage,
          pagesVisible: 3,
          onPageChanged: viewModel.changePage,
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: TextField(
                controller: viewModel.queryController,
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 15),
                onChanged: (value) => viewModel.search(query: value),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: _kCard,
                  prefixIcon: const Icon(Icons.search_rounded,
                      color: Color(0xFF8A8A9A), size: 20),
                  hintText: 'Search movies...',
                  hintStyle: GoogleFonts.poppins(
                      color: const Color(0xFF4A4A5A), fontSize: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                        const BorderSide(color: Color(0xFF2A2A3E), width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                        const BorderSide(color: Color(0xFF2A2A3E), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: _kAccent, width: 1.5),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: viewModel.hasError
                  ? Center(
                      child: Text(viewModel.modelError.toString(),
                          style: GoogleFonts.poppins(color: Colors.white70)))
                  : viewModel.isBusy
                      ? Skeletonizer(
                          enabled: true,
                          effect: const ShimmerEffect(
                            baseColor: Color(0xFF1A2339),
                            highlightColor: Color(0xFF293757),
                            duration: Duration(milliseconds: 1250),
                          ),
                          child: GridView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              childAspectRatio: 0.6,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: 12,
                            itemBuilder: (_, __) => Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF2A2A3E),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: 0.6,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: viewModel.results?.results.length ?? 0,
                          itemBuilder: (_, index) {
                            final movie = viewModel.results!.results[index];
                            return MoviesWidget(
                              title: movie.title ?? '',
                              posterPath:
                                  'https://image.tmdb.org/t/p/w300${movie.posterPath ?? ''}',
                              id: movie.id,
                              onTap: () =>
                                  viewModel.navigateToMovieDetails(movie.id),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  SearchViewModel viewModelBuilder(BuildContext context) => SearchViewModel();

  @override
  void onViewModelReady(SearchViewModel viewModel) => viewModel.search(
        query: viewModel.queryController.text,
      );
}
