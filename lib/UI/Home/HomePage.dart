import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movistar/UI/Details/MovieDetailsPage.dart';
import 'package:movistar/UI/Home/Widget/CarouselWidgetPage.dart';
import 'package:movistar/UI/Home/Widget/DrawerWidget.dart';
import 'package:movistar/UI/Home/Widget/GenreMoviesPage.dart';
import 'package:movistar/UI/Home/Widget/MovieWidget.dart';
import 'package:movistar/UI/Home/Widget/PopularMoviesPage.dart';
import 'package:movistar/UI/Home/Widget/TitleWidget.dart';
import 'package:movistar/UI/Home/Widget/TopRatedMoviesPage.dart';
// import 'package:movistar/UI/Home/Widget/TopRatedMoviesPage.dart';
import 'package:movistar/UI/Home/Widget/TrendingMoviesPage.dart';
import 'package:movistar/Util/Responsive.dart';
import 'package:movistar/blocs/Homebloc/home_bloc.dart';
import 'package:movistar/blocs/SearchMovie/search_movie_bloc.dart';


class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final movieController = TextEditingController()..addListener(() {});
  late HomeBloc homeBloc;

  late FocusNode searchNode;
  bool singleChildWrap = false;
  final GlobalKey<ScaffoldState> _sKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    searchNode = FocusNode();
    homeBloc = context.read<HomeBloc>()..add(GetHome(page: page));
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

    homeBloc.add(GetHome(page: page));
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
      child: BlocProvider(
          create: (context) => HomeBloc()..add(GetHome(page: page)),
          child: Scaffold(
              key: _sKey,
              backgroundColor: Colors.black,
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SingleChildScrollView(
                  child: RefreshIndicator(
                    onRefresh: () {
                      homeBloc.add(GetHome(page: page));
                      return Future.value();
                    },
                    child: BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) {
                        if (state is HomeLoading) {
                          return const Align(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator());
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
                                                    fontSize:
                                                        MediaQuery.of(context)
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
                                                  context.pushNamed(
                                                      "search",
                                                      );
                                                },
                                                style: GoogleFonts.poppins(
                                                    color: Colors.white),
                                                controller: movieController,
                                                decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.grey[800],
                                                    prefixIcon: const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      child: Icon(
                                                        Icons.search,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    hintStyle:
                                                        GoogleFonts.poppins(
                                                            color: Colors
                                                                .white),
                                                    hintText: "Search Movie",
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 10),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
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
                                                              25),
                                                      borderSide:
                                                          const BorderSide(
                                                              color: Colors
                                                                  .transparent,
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
                                              SizedBox(
                                                child: TextFormField(
                                                  keyboardType: TextInputType.none,
                                                readOnly: true,
                                                showCursor: true,
                                                  onTap: () {
                                                    context.pushNamed(
                                                        "search",
                                                        );
                                                  },
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.white),
                                                  controller: movieController,
                                                  decoration: InputDecoration(
                                                      filled: true,
                                                      fillColor:
                                                          Colors.grey[800],
                                                      prefixIcon: const Icon(
                                                        Icons.search,
                                                        color: Colors.white,
                                                      ),
                                                      hintStyle:
                                                          GoogleFonts.poppins(
                                                              color:
                                                                  Colors.white),
                                                      hintText: "Search Movie",
                                                      contentPadding:
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              horizontal: 5),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .transparent,
                                                                width: 1),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
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
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: const [
                                                  Text(
                                                    "Movistar",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 25),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "On Demand",
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 18),
                                                  ),
                                                ],
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10),

                                      // Popular Movies

                                      const TitleMovie(title: "Popular Movies"),
                                      PopularMovies(state: state.popular),
                                      //top rated

                                      const TitleMovie(
                                          title: "Top Rated Movies"),
                                      TopRatedMovies(
                                        state: state.topRated,
                                      ),

                                      // Trending Movies

                                      const TitleMovie(
                                          title: "Trending Movies"),
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
              ))

          // mobile

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
