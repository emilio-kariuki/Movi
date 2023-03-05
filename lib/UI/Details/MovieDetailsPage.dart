import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movistar/UI/Widget/CastsWidget.dart';
import 'package:movistar/UI/Widget/DrawerWidget.dart';
import 'package:movistar/UI/Widget/LiquidSpinner.dart';

import 'package:movistar/UI/Widget/MovieWidget.dart';
import 'package:movistar/UI/Widget/TitleWidget.dart';
import 'package:movistar/Util/Responsive.dart';
import 'package:movistar/blocs/Casts_bloc/casts_bloc.dart';
import 'package:movistar/blocs/movieDetails_bloc/movie_details_bloc.dart';
import 'package:movistar/blocs/similar_bloc/similar_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MovieDetails extends StatefulWidget {
  MovieDetails({super.key, required this.id});

  final String id;

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  String url =
      "https://firebasestorage.googleapis.com/v0/b/apt-rite-346310.appspot.com/o/profile.jpg?alt=media&token=71a31f30-11ee-49b9-913c-b3682d3f6ea7";

  formatedTime({required int time}) {
    int min = time % 60;
    int hours = (time / 60).floor();
    String hour = hours.toString().length <= 1 ? "0$hours" : "$hours";
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    return "$hours hr $minute min";
  }

  formatedDate({required DateTime date}) {
    return "${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("the movie id is ${widget.id}");
    return MediaQuery.of(context).size.width > 700
        ? MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => MovieDetailsBloc()
                  ..add(GetMovieDetails(movieId: int.parse(widget.id))),
              ),
              BlocProvider(
                create: (context) => SimilarBloc()
                  ..add(GetSimilar(movieId: int.parse(widget.id))),
              ),
              BlocProvider(
                create: (context) =>
                    CastsBloc()..add(GetCasts(movieId: int.parse(widget.id))),
              ),
            ],
            child: Scaffold(
              backgroundColor: Colors.black,
              body: SingleChildScrollView(
                  child: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
                builder: (context, state) {
                  if (state is MovieDetailsLoading) {
                    return Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.5),
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                        ),
                      ),
                    );
                  } else if (state is MovieDetailsLoaded) {
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          color: const Color.fromARGB(255, 26, 26, 26),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 20,
                              ),
                              Stack(
                                children: [
                                  CachedNetworkImage(
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                    imageUrl:
                                        "https://image.tmdb.org/t/p/original///${state.movieDetails.posterPath}",
                                    fit: BoxFit.fill,
                                    imageBuilder: (context, imageProvider) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    },
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                      Icons.error,
                                      color: Colors.red,
                                      size: 18,
                                    ),
                                  ),
                                  Positioned.fill(
                                    bottom: 10,
                                    left: 10,
                                    child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              state.movieDetails.title,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.1),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        )),
                                  ),
                                  
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.movieDetails.title,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.1),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),

                                  //imdb

                                  Row(
                                    children: [
                                      CircularPercentIndicator(
                                        radius: 25.0,
                                        lineWidth: 5.0,
                                        percent:
                                            state.movieDetails.voteAverage / 10,
                                        center: SizedBox(
                                          child: Text(
                                            "${((state.movieDetails.voteAverage) * 10).toStringAsFixed(0)}%",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.0,
                                                color: Colors.white),
                                          ),
                                        ),
                                        progressColor: Colors.green,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          formatedDate(
                                              date: state
                                                  .movieDetails.releaseDate),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                              letterSpacing: 0.1)),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        height: 15,
                                        width: 1,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          formatedTime(
                                              time: state.movieDetails.runtime),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                              letterSpacing: 0.1)),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        height: 15,
                                        width: 1,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Image.asset(
                                        "lib/assets/imdb.png",
                                        height: 40,
                                        width: 30,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          "${state.movieDetails.voteAverage} / 10",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                              letterSpacing: 0.1)),
                                    ],
                                  ),

                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "# ${state.movieDetails.tagline}",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.1),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.6,
                                    ),
                                    child: Text(
                                      state.movieDetails.overview,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal,
                                          letterSpacing: 0.1),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "Keywords",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.normal,
                                        letterSpacing: 0.1),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    constraints: BoxConstraints(
                                        maxHeight: 30,
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.6),
                                    child: SizedBox(
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            state.keywords.keywords.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 2),
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.black,
                                            ),
                                            child: Text(
                                                state.keywords.keywords[index]
                                                    .name,
                                                style: const TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    letterSpacing: 0.1)),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "Genres",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.normal,
                                        letterSpacing: 0.1),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    constraints: BoxConstraints(
                                        maxHeight: 30,
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.6),
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          state.movieDetails.genres.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 2),
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.black,
                                          ),
                                          child: Text(
                                              state.movieDetails.genres[index]
                                                  .name,
                                              style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.normal,
                                                  letterSpacing: 0.1)),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Responsive.isDesktop(context)
                                  ? MediaQuery.of(context).size.width * 0.01
                                  : 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Cast",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.1),
                              ),
                              MediaQuery.of(context).size.height > 900
                                  ? const SizedBox(
                                      height: 10,
                                    )
                                  : Container(),
                              SizedBox(
                                height: MediaQuery.of(context).size.width > 900
                                    ? MediaQuery.of(context).size.height * 0.27
                                    : MediaQuery.of(context).size.height * 0.27,
                                child: BlocBuilder<CastsBloc, CastsState>(
                                  builder: (context, state) {
                                    if (state is CastsInitial) {
                                      return Container(
                                        margin: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.5),
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3,
                                          ),
                                        ),
                                      );
                                    } else if (state is CastsLoading) {
                                      return Container(
                                        margin: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.5),
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 3,
                                          ),
                                        ),
                                      );
                                    } else if (state is CastsLoaded) {
                                      return ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: state.casts.cast.length,
                                        itemBuilder: (context, index) {
                                          return CastsWidget(
                                            posterPath: state
                                                .casts.cast[index].profilePath,
                                            castId: state.casts.cast[index].id
                                                .toString(),
                                            name: state.casts.cast[index].name,
                                            role: state.casts.cast[index]
                                                .knownForDepartment,
                                          );
                                        },
                                      );
                                    } else if (state is CastsError) {
                                      return Center(
                                        child: Text(state.message),
                                      );
                                    } else {
                                      return const Center(
                                        child: Text("Error"),
                                      );
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "For You",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.1),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.width > 900
                                          ? MediaQuery.of(context).size.height *
                                              0.38
                                          : MediaQuery.of(context).size.height *
                                              0.27,
                                  child: BlocBuilder<SimilarBloc, SimilarState>(
                                    builder: (context, state) {
                                      if (state is SimilarInitial) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (state is SimilarLoading) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (state is SimilarLoaded) {
                                        return SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.26,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                state.similar.results.length,
                                            itemBuilder: (context, index) {
                                              return MoviesWidget(
                                                id: state
                                                    .similar.results[index].id,
                                                title: state.similar
                                                        .results[index].title ??
                                                    " ",
                                                posterPath:
                                                    "https://image.tmdb.org/t/p/original/${state.similar.results[index].posterPath}",
                                              );
                                            },
                                          ),
                                        );
                                      } else if (state is SimilarError) {
                                        return Center(
                                            child: Text(state.message));
                                      } else {
                                        return const Center(
                                            child: Text("Error"));
                                      }
                                    },
                                  )),
                              const TitleMovie(title: "Reviews"),
                              const SizedBox(
                                height: 10,
                              ),
                              // state.reviews.results.isNotEmpty
                              //     ? SizedBox(
                              //         height:
                              //             MediaQuery.of(context).size.height *
                              //                 0.2,
                              //         child: Column(
                              //           children: [
                              //             Row(
                              //               children: [
                              //                 CachedNetworkImage(
                              //                   width: 50.0,
                              //                   height: 50.0,
                              //                   imageUrl:
                              //                       "https://image.tmdb.org/t/p/original/${state.reviews.results[0].authorDetails!.avatarPath}",
                              //                   imageBuilder:
                              //                       (context, imageProvider) {
                              //                     return Container(
                              //                       decoration: BoxDecoration(
                              //                         shape: BoxShape.circle,
                              //                         image: DecorationImage(
                              //                             image: imageProvider,
                              //                             fit: BoxFit.cover),
                              //                       ),
                              //                     );
                              //                   },
                              //                 ),
                              //                 const SizedBox(
                              //                   width: 10,
                              //                 ),
                              //                 Column(
                              //                   children: [
                              //                     Text(
                              //                       state.reviews.results[0]
                              //                           .author!,
                              //                       style: const TextStyle(
                              //                           color: Colors.white,
                              //                           fontSize: 18,
                              //                           fontWeight:
                              //                               FontWeight.bold),
                              //                     ),
                              //                     Container(
                              //                       constraints: BoxConstraints(
                              //                           maxHeight:
                              //                               MediaQuery.of(
                              //                                           context)
                              //                                       .size
                              //                                       .height *
                              //                                   0.3,
                              //                           maxWidth: MediaQuery.of(
                              //                                       context)
                              //                                   .size
                              //                                   .width *
                              //                               0.6),
                              //                       child: Text(
                              //                         state.reviews.results[0]
                              //                             .content!,
                              //                         style: const TextStyle(
                              //                             color: Colors.white,
                              //                             fontSize: 14,
                              //                             fontWeight:
                              //                                 FontWeight.bold),
                              //                       ),
                              //                     ),
                              //                   ],
                              //                 )
                              //               ],
                              //             ),
                              //           ],
                              //         ))
                              //     : Container(),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else if (state is MovieDetailsError) {
                    return Center(child: Text(state.message));
                  } else {
                    return const Center(child: Text("Error"));
                  }
                },
              )),
            ),
          )

        //mobile view
        : MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => MovieDetailsBloc()
                  ..add(GetMovieDetails(movieId: int.parse(widget.id))),
              ),
              BlocProvider(
                create: (context) => SimilarBloc()
                  ..add(GetSimilar(movieId: int.parse(widget.id))),
              ),
              BlocProvider(
                create: (context) =>
                    CastsBloc()..add(GetCasts(movieId: int.parse(widget.id))),
              ),
            ],
            child: Scaffold(
              drawer: const DrawerPage(),
              backgroundColor: Colors.black,
              body: SafeArea(
                child: SingleChildScrollView(
                    child: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
                  builder: (context, state) {
                    if (state is MovieDetailsLoading) {
                      return Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.5),
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                          ),
                        ),
                      );
                    } else if (state is MovieDetailsLoaded) {
                      return Column(
                        children: [
                          Stack(
                            children: [
                              CachedNetworkImage(
                                height: MediaQuery.of(context).size.width > 600
                                    ? MediaQuery.of(context).size.height * 0.5
                                    : MediaQuery.of(context).size.height * 0.25,
                                width: MediaQuery.of(context).size.width,
                                imageUrl:
                                    "https://image.tmdb.org/t/p/original///${state.movieDetails.posterPath}",
                                fit: BoxFit.fill,
                                imageBuilder: (context, imageProvider) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      ),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                  size: 18,
                                ),
                              ),
                              Positioned.fill(
                                bottom: 10,
                                left: 10,
                                child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          state.movieDetails.title,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.1),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          height: 30,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.85,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: state
                                                .movieDetails.genres.length,
                                            itemBuilder: (context, index) {
                                              return GenreContainer(
                                                  genre: state.movieDetails
                                                      .genres[index].name);
                                            },
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                              Positioned.fill(
                                top: 10,
                                left: 10,
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 5),
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(
                                          Icons.arrow_back_ios,
                                          color: Colors.black,
                                          size: 20,
                                        ),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: kIsWeb
                                    ? MediaQuery.of(context).size.width * 0.01
                                    : 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.movieDetails.title,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.1),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),

                                //imdb

                                Row(
                                  children: [
                                    Text(
                                        formatedDate(
                                            date:
                                                state.movieDetails.releaseDate),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                            letterSpacing: 0.1)),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      height: 15,
                                      width: 1,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                        formatedTime(
                                            time: state.movieDetails.runtime),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                            letterSpacing: 0.1)),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      height: 15,
                                      width: 1,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Image.asset(
                                      "lib/assets/imdb.png",
                                      height: 40,
                                      width: 30,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                        "${state.movieDetails.voteAverage} / 10",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.normal,
                                            letterSpacing: 0.1)),
                                  ],
                                ),

                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "# ${state.movieDetails.tagline}",
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.1),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  state.movieDetails.overview,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                      letterSpacing: 0.1),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "Cast",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.1),
                                ),
                                MediaQuery.of(context).size.height > 900
                                    ? const SizedBox(
                                        height: 10,
                                      )
                                    : Container(),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.width > 900
                                          ? MediaQuery.of(context).size.height *
                                              0.27
                                          : MediaQuery.of(context).size.height *
                                              0.27,
                                  child: BlocBuilder<CastsBloc, CastsState>(
                                    builder: (context, state) {
                                      if (state is CastsInitial) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else if (state is CastsLoading) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else if (state is CastsLoaded) {
                                        return ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: state.casts.cast.length,
                                          itemBuilder: (context, index) {
                                            return CastsWidget(
                                              posterPath: state.casts
                                                  .cast[index].profilePath,
                                              castId: state.casts.cast[index].id
                                                  .toString(),
                                              name:
                                                  state.casts.cast[index].name,
                                              role: state.casts.cast[index]
                                                  .knownForDepartment,
                                            );
                                          },
                                        );
                                      } else if (state is CastsError) {
                                        return Center(
                                          child: Text(state.message),
                                        );
                                      } else {
                                        return const Center(
                                          child: Text("Error"),
                                        );
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "For You",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.1),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height:
                                        MediaQuery.of(context).size.width > 900
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.38
                                            : MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.27,
                                    child:
                                        BlocBuilder<SimilarBloc, SimilarState>(
                                      builder: (context, state) {
                                        if (state is SimilarInitial) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else if (state is SimilarLoading) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else if (state is SimilarLoaded) {
                                          return SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.26,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  state.similar.results.length,
                                              itemBuilder: (context, index) {
                                                return MoviesWidget(
                                                  id: state.similar
                                                      .results[index].id,
                                                  title: state
                                                          .similar
                                                          .results[index]
                                                          .title ??
                                                      " ",
                                                  posterPath:
                                                      "https://image.tmdb.org/t/p/original/${state.similar.results[index].posterPath}",
                                                );
                                              },
                                            ),
                                          );
                                        } else if (state is SimilarError) {
                                          return Center(
                                              child: Text(
                                            state.message,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ));
                                        } else {
                                          return const Center(
                                              child: Text(
                                            "Error",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ));
                                        }
                                      },
                                    )),
                              ],
                            ),
                          ),
                        ],
                      );
                    } else if (state is MovieDetailsError) {
                      return Center(child: Text(state.message));
                    } else {
                      return const Center(
                          child: Text(
                        "Error",
                        style: TextStyle(color: Colors.white),
                      ));
                    }
                  },
                )),
              ),
            ),
          );
  }
}

class GenreContainer extends StatelessWidget {
  const GenreContainer({super.key, required this.genre});

  final String genre;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 5),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width > 400
            ? MediaQuery.of(context).size.width * 0.1
            : MediaQuery.of(context).size.width * 0.2,
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 20,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          genre,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.1),
        ),
      ),
    );
  }
}
