import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movistar/UI/Home/Widget/MovieWidget.dart';
import 'package:movistar/blocs/topRated_bloc/top_rated_bloc.dart';
import 'package:movistar/blocs/trending_bloc/trending_bloc.dart';

class TopRatedMovies extends StatelessWidget {
  const TopRatedMovies({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopRatedBloc, TopRatedState>(
              builder: (context, state) {
                if (state is TopRatedInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TopRatedLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TopRatedLoaded) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.26,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.topRated.results.length,
                      itemBuilder: (context, index) {
                        return MoviesWidget(
                          title:
                              state.topRated.results[index].title,
                          posterPath:
                              "https://image.tmdb.org/t/p/original/${state.topRated.results[index].posterPath}",
                        );
                      },
                    ),
                  );
                } else if (state is TopRatedError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text("Error"));
                }
              },
            );
  }
}

