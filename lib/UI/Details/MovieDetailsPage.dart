import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movistar/UI/Details/Widgets/CastsWidget.dart';
import 'package:movistar/UI/Home/Widget/MovieWidget.dart';
import 'package:movistar/blocs/Casts_bloc/casts_bloc.dart';
import 'package:movistar/blocs/movieDetails_bloc/movie_details_bloc.dart';
import 'package:movistar/blocs/similar_bloc/similar_bloc.dart';

class MovieDetails extends StatefulWidget {
  final String id;
  MovieDetails({super.key, required this.id});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  String url =
      "https://firebasestorage.googleapis.com/v0/b/apt-rite-346310.appspot.com/o/profile.jpg?alt=media&token=71a31f30-11ee-49b9-913c-b3682d3f6ea7";

  late final MovieDetailsBloc _movieDetailsBloc;
  late final SimilarBloc _similarBloc;
  late final CastsBloc _castsBloc;

  @override
  void initState() {
    super.initState();
    _movieDetailsBloc = BlocProvider.of<MovieDetailsBloc>(context)
      ..add(GetMovieDetails(movieId: int.parse(widget.id)));
    _similarBloc = BlocProvider.of<SimilarBloc>(context)
      ..add(GetSimilar(movieId: int.parse(widget.id)));
    _castsBloc = BlocProvider.of<CastsBloc>(context)
      ..add(GetCasts(movieId: int.parse(widget.id)));
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("the movie id is ${widget.id}");
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
            child: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
          builder: (context, state) {
            if (state is MovieDetailsInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieDetailsLoaded) {
              return Column(
                children: [
                  Stack(
                    children: [
                      CachedNetworkImage(
                        height: MediaQuery.of(context).size.height * 0.25,
                        width: MediaQuery.of(context).size.width,
                        imageUrl:
                            "https://image.tmdb.org/t/p/original/${state.movieDetails.posterPath}",
                        fit: BoxFit.cover,
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
                        errorWidget: (context, url, error) => const Icon(
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
                                SizedBox(
                                  height: 30,
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: state.movieDetails.genres.length,
                                    itemBuilder: (context, index) {
                                      return GenreContainer(
                                          genre: state
                                              .movieDetails.genres[index].name);
                                    },
                                  ),
                                )
                              ],
                            )),
                      ),
                      // Positioned.fill(
                      //   top: 10,
                      //   left: 10,
                      //   child: Align(
                      //       alignment: Alignment.topRight,
                      //       child: Container(
                      //         height: 40,
                      //         width: 40,
                      //         decoration: BoxDecoration(
                      //           borderRadius: BorderRadius.circular(10),
                      //           color: Colors.white,
                      //         ),
                      //         child: Center(
                      //           child: IconButton(
                      //             onPressed: () {
                      //               context.pushReplacementNamed("home");
                      //             },
                      //             icon: const Icon(
                      //               Icons.home,
                      //               color: Colors.black,
                      //             ),
                      //           ),
                      //         ),
                      //       )),
                      // ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
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
                        height: 10,
                      ),

                      //imdb

                      Row(
                        children: [
                          Text(
                              formatedDate(
                                  date: state.movieDetails.releaseDate),
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
                          Text(formatedTime(time: state.movieDetails.runtime),
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
                          Text("${state.movieDetails.voteAverage} / 10",
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
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.2,
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
                                    posterPath:
                                        state.casts.cast[index].profilePath,
                                    castId:
                                        state.casts.cast[index].id.toString(),
                                    name: state.casts.cast[index].name,
                                    role: state
                                        .casts.cast[index].knownForDepartment,
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
                          height: MediaQuery.of(context).size.height * 0.3,
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
                                  height:
                                      MediaQuery.of(context).size.height * 0.26,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: state.similar.results.length,
                                    itemBuilder: (context, index) {
                                      return MoviesWidget(
                                        id: state.similar.results[index].id,
                                        title:
                                            state.similar.results[index].title,
                                        posterPath:
                                            "https://image.tmdb.org/t/p/original/${state.similar.results[index].posterPath}",
                                      );
                                    },
                                  ),
                                );
                              } else if (state is SimilarError) {
                                return Center(child: Text(state.message));
                              } else {
                                return const Center(child: Text("Error"));
                              }
                            },
                          )),
                    ],
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
    );
  }

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
}

class GenreContainer extends StatelessWidget {
  final String genre;
  const GenreContainer({super.key, required this.genre});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 5),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.2,
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
