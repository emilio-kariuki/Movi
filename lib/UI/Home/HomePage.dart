import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movistar/UI/Details/MovieDetailsPage.dart';
import 'package:movistar/UI/Home/SearchPage.dart';

import 'package:movistar/UI/Widget/CarouselWidgetPage.dart';
import 'package:movistar/UI/Widget/GenreMoviesPage.dart';
import 'package:movistar/UI/Widget/PopularMoviesPage.dart';
import 'package:movistar/UI/Widget/TitleWidget.dart';
import 'package:movistar/UI/Widget/TrendingMoviesPage.dart';
import 'package:movistar/Util/Responsive.dart';
import 'package:movistar/blocs/Casts_bloc/casts_bloc.dart';
import 'package:movistar/blocs/Homebloc/home_bloc.dart';
import 'package:movistar/blocs/SearchMovie/search_movie_bloc.dart';
import 'package:movistar/blocs/movieDetails_bloc/movie_details_bloc.dart';
import 'package:movistar/blocs/movieGenre_bloc/movie_genre_bloc.dart';
import 'package:movistar/blocs/similar_bloc/similar_bloc.dart';

import '../Widget/TopRatedMoviesPage.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final movieController = TextEditingController()..addListener(() {});

  late FocusNode searchNode;
  bool singleChildWrap = false;
  final GlobalKey<ScaffoldState> _sKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    searchNode = FocusNode();
  }

  @override
  void dispose() {
    movieController.dispose();
    searchNode.dispose();
    super.dispose();
  }

  late DateTime current;
  int page = Random().nextInt(300);
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
            create: (context) => CastsBloc()..add(GetCasts(movieId: 24)),
          ),
          BlocProvider<SimilarBloc>(
            create: (context) => SimilarBloc()..add(GetSimilar(movieId: 24)),
          ),
          BlocProvider<MovieGenreBloc>(
            create: (context) => MovieGenreBloc()..add(GetMovieGenre()),
          ),
          BlocProvider<SearchMovieBloc>(
              create: (context) =>
                  SearchMovieBloc()..add(GetMovie(title: "g", page: 1))),
          BlocProvider<HomeBloc>(
            create: (context) => HomeBloc()..add(GetHome(page: 1)),
          ),
        ],
        child: Scaffold(
          key: _sKey,
          backgroundColor: Colors.black,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                        margin:  EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.5),
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
                                  horizontal: 15, vertical: 10),
                              child: Responsive.isDesktop(context) ||
                                      Responsive.isTablet(context)
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Movistar",
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
                                                      builder: (context) =>
                                                          SearchPage()));
                                            
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
                                                    color: Colors.white,fontSize: 11),
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
                                          const Text(
                                            "Movistar",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25),
                                          ),
                                          const SizedBox(height: 20,),
                                          SizedBox(
                                            height: 40,
                                            child: TextFormField(
                                              keyboardType: TextInputType.none,
                                              readOnly: true,
                                              showCursor: true,
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SearchPage()));
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
                                  const SizedBox(height: 10),

                                  // Popular Movies

                                  const TitleMovie(title: "Popular Movies"),
                                  PopularMovies(state: state.popular),
                                  //top rated

                                  const TitleMovie(title: "Top Rated Movies"),
                                  TopRatedMovies(
                                    state: state.topRated,
                                  ),

                                  // Trending Movies

                                  const TitleMovie(title: "Trending Movies"),
                                  TrendingMovies(
                                    state: state.trending,
                                  ),

                                  const TitleMovie(title: "All Genres"),
                                  GenreMovies(
                                    state: state.genreList,
                                  ),
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
