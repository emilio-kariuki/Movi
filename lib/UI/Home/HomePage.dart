import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movi/UI/Home/GenreMovies.dart';
import 'package:movi/UI/Home/SearchPage.dart';
import 'package:movi/UI/Home/ViewAll/PopularMovies.dart';
import 'package:movi/UI/Home/ViewAll/TopRatedMovies.dart';
import 'package:movi/UI/Home/ViewAll/TrendingMovies.dart';
import 'package:movi/UI/Widget/CarouselWidgetPage.dart';
import 'package:movi/UI/Widget/PopularMoviesPage.dart';
import 'package:movi/UI/Widget/ProfileCard.dart';
import 'package:movi/UI/Widget/TitleWidget.dart';
import 'package:movi/UI/Widget/TrendingMoviesPage.dart';
import 'package:movi/Util/Responsive.dart';
import 'package:movi/blocs/Casts_bloc/casts_bloc.dart';
import 'package:movi/blocs/Homebloc/home_bloc.dart';
import 'package:movi/blocs/SearchMovie/search_movie_bloc.dart';
import 'package:movi/blocs/movieDetails_bloc/movie_details_bloc.dart';
import 'package:movi/blocs/movieGenre_bloc/movie_genre_bloc.dart';
import 'package:movi/blocs/similar_bloc/similar_bloc.dart';
import '../Widget/TopRatedMoviesPage.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late DateTime current;
  final movieController = TextEditingController()..addListener(() {});
  int page = Random().nextInt(300);
  late FocusNode searchNode;
  bool singleChildWrap = false;

  final GlobalKey<ScaffoldState> _sKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    movieController.dispose();
    searchNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    searchNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    int page = Random().nextInt(300);

    HomeBloc().add(GetHome(page: page));
    Future<bool> popped() {
      DateTime now = DateTime.now();
      if (now.difference(current) > const Duration(seconds: 2)) {
        current = now;
        Fluttertoast.showToast(
          msg: "Press back again to exit",
          toastLength: Toast.LENGTH_SHORT,
        );
        return Future.value(false);
      } else {
        Fluttertoast.cancel();
        return Future.value(true);
      }
    }

    return WillPopScope(
      onWillPop: () => popped(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeBloc()..add(GetHome(page: page)),
          ),
          BlocProvider<MovieDetailsBloc>(
            create: (context) =>
                MovieDetailsBloc()..add(GetMovieDetails(movieId: 24)),
          ),
          BlocProvider<CastsBloc>(
            create: (context) => CastsBloc(),
          ),
          BlocProvider<SimilarBloc>(
            create: (context) => SimilarBloc(),
          ),
          BlocProvider<HomeBloc>(
            create: (context) => HomeBloc()..add(GetHome(page: 1)),
          ),
          BlocProvider(
            create: (context) =>
                SearchMovieBloc()..add(GetMovie(title: 'a', page: 1)),
          ),
        ],
        child: Scaffold(
          key: _sKey,
          backgroundColor: Colors.black,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: SingleChildScrollView(
              child: RefreshIndicator(
                onRefresh: () {
                  HomeBloc().add(GetHome(page: page));
                  return Future.value();
                },
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is HomeLoading) {
                      return Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.5),
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                          ),
                        ),
                      );
                    } else if (state is HomeLoaded) {
                      return SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //search bar

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 10),
                              child: Responsive.isDesktop(context) ||
                                      Responsive.isTablet(context)
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("movi",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: MediaQuery.of(context)
                                                            .size
                                                            .width >
                                                        600
                                                    ? 30
                                                    : 20)),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  900
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3
                                              : MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                          child: TextFormField(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) => BlocProvider.value(
                                                        value: BlocProvider.of<
                                                                SearchMovieBloc>(
                                                            context),
                                                        child:
                                                            const SearchPage())),
                                              );
                                            },
                                            style: GoogleFonts.poppins(
                                                color: Colors.white),
                                            controller: movieController,
                                            decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.grey[800],
                                                prefixIcon: const Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 10),
                                                  child: Icon(
                                                    Icons.search,
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                ),
                                                hintStyle: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 11),
                                                hintText: "Search Movie",
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: const BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: const BorderSide(
                                                      color: Colors.transparent,
                                                      width: 1),
                                                )),
                                          ),
                                        ),
                                        ProfileCard(
                                          name: "Emilio Kariuki",
                                          image:
                                              "https://image.tmdb.org/t/p/original/${state.popular.results[0].posterPath}",
                                        ),
                                      ],
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          // horizontal: 15,
                                          vertical: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "movi",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 25),
                                              ),
                                              ProfileCard(
                                                name: "Emilio Kariuki",
                                                image:
                                                    "https://image.tmdb.org/t/p/original/${state.popular.results[0].posterPath}",
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          SizedBox(
                                            height: 45,
                                            child: TextFormField(
                                              keyboardType: TextInputType.none,
                                              readOnly: true,
                                              showCursor: true,
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const SearchPage()));
                                              },
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white),
                                              controller: movieController,
                                              decoration: InputDecoration(
                                                  filled: true,
                                                  fillColor: Colors.grey[800],
                                                  prefixIcon: const Icon(
                                                    Icons.search,
                                                    color: Colors.white,
                                                  ),
                                                  hintStyle:
                                                      GoogleFonts.poppins(
                                                          color: Colors.white),
                                                  hintText: "Search Movie",
                                                  contentPadding:
                                                      const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 5),
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors
                                                                .transparent,
                                                            width: 1),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors
                                                                .transparent,
                                                            width: 1),
                                                  )),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                            ),

                            const CarouselWidget(),

                            //carousel slider

                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),

                                  //* Popular Movies

                                  TitleMovie(
                                    title: "Popular Movies",
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ViewAllPopular()));
                                    },
                                  ),
                                  PopularMovies(state: state.popular),
                                  const SizedBox(height: 10),

                                  //* top rated

                                  TitleMovie(
                                    title: "Top Rated Movies",
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ViewAllTopRated()));
                                    },
                                  ),
                                  const SizedBox(height: 5),

                                  TopRatedMovies(
                                    state: state.topRated,
                                  ),
                                  const SizedBox(height: 20),

                                  //* Trending Movies

                                  TitleMovie(
                                    title: "Trending Movies",
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ViewAllTrending()));
                                    },
                                  ),
                                  const SizedBox(height: 5),

                                  TrendingMovies(
                                    state: state.trending,
                                  ),
                                  const SizedBox(height: 20),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text("Top Genres",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  BlocProvider(
                                    create: (context) =>
                                        MovieGenreBloc()..add(GetGenres()),
                                    child: BlocBuilder<MovieGenreBloc,
                                        MovieGenreState>(
                                      builder: (context, state) {
                                        if (state is MovieGenreLoading) {
                                          return const Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 3,
                                            ),
                                          );
                                        } else if (state is MovieGenreLoaded) {
                                          return SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: GridView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: Responsive
                                                              .isDesktop(
                                                                  context) ||
                                                          Responsive.isTablet(
                                                              context)
                                                      ? 5
                                                      : 3,
                                                  childAspectRatio: 2,
                                                  mainAxisSpacing: 5,
                                                  crossAxisSpacing: 5,
                                                ),
                                                itemCount:
                                                    state.genre.genres.length,
                                                itemBuilder: (context, index) {
                                                  final randomColor = Color(
                                                          (Random().nextDouble() *
                                                                      0xFFFFFF)
                                                                  .toInt() <<
                                                              0)
                                                      .withOpacity(0.6);
                                                  return GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    GenreMovies(
                                                                      genreId: state
                                                                          .genre
                                                                          .genres[
                                                                              index]
                                                                          .id,
                                                                      genreName: state
                                                                          .genre
                                                                          .genres[
                                                                              index]
                                                                          .name,
                                                                    )),
                                                      );
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: randomColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          state
                                                              .genre
                                                              .genres[index]
                                                              .name,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            color: Colors.white,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          );
                                        } else {
                                          return const Center(
                                              child: Text(
                                            "Could not fetch genres",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 12,
                                            ),
                                          ));
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      return const Center(child: Text("Error"));
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomPhysics extends ScrollPhysics {
  const CustomPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  CustomPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 150,
        stiffness: 200,
        damping: 1,
      );
}
