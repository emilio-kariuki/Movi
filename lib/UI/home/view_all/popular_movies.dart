import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movi/UI/widget/movie_widget.dart';
import 'package:movi/blocs/home_bloc/home_bloc.dart';
import 'package:movi/util/responsive.dart';
import 'package:pagination_flutter/pagination.dart';

class ViewAllPopular extends StatefulWidget {
  const ViewAllPopular({
    super.key,
  });

  @override
  State<ViewAllPopular> createState() => _ViewAllPopularState();
}

class _ViewAllPopularState extends State<ViewAllPopular> {
  int _current = 1;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(GetPopular(page: _current)),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.black54,
            title: const Text("Popular",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500)),
          ),
          backgroundColor: Colors.black,
          bottomNavigationBar: Pagination(
            numOfPages: 100,
            selectedPage: _current,
            pagesVisible: 3,
            onPageChanged: (page) {
              setState(() {
                _current = page;
                BlocProvider.of<HomeBloc>(context)
                    .add(GetPopular(page: _current));
              });
            },
            nextIcon: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.blue,
              size: 14,
            ),
            previousIcon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.blue,
              size: 14,
            ),
            activeTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            activeBtnStyle: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(38),
                ),
              ),
            ),
            inactiveBtnStyle: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(38),
              )),
            ),
            inactiveTextStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (_, state) {
                  if (state is HomeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is PopularLoaded) {
                    return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: Responsive.isDesktop(context)
                                ? 9
                                : Responsive.isTablet(context)
                                    ? 7
                                    : Responsive.isMobile(context)
                                        ? 3
                                        : 3,
                            childAspectRatio: Responsive.isTablet(context)
                                ? 0.5
                                : Responsive.isDesktop(context)
                                    ? 0.57
                                    : Responsive.isMobile(context)
                                        ? 0.58
                                        : 0.58),
                        itemCount: state.popular.results.length,
                        itemBuilder: (_, index) {
                          return MoviesWidget(
                              title: state.popular.results[index].title ?? "",
                              posterPath:
                                  // ignore: prefer_interpolation_to_compose_strings
                                  "https://image.tmdb.org/t/p/w500" +
                                      (state.popular.results[index]
                                              .posterPath ??
                                          state.popular.results[index + 4]
                                              .posterPath!),
                              id: state.popular.results[index].id);
                        });
                  } else if (state is HomeError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text(
                        "Search for a movie",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}
