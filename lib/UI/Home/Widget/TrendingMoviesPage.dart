import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movistar/UI/Home/Widget/MovieWidget.dart';
import 'package:movistar/blocs/trending_bloc/trending_bloc.dart';

class TrendingMovies extends StatelessWidget {
  const TrendingMovies({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TrendingBloc, TrendingState>(
              builder: (context, state) {
                if (state is TrendingInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TrendingLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TrendingLoaded) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.26,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.trending.results.length,
                      itemBuilder: (context, index) {
                        return MoviesWidget(
                          title:
                              state.trending.results[index].title ?? "unknown",
                          posterPath:
                              "https://image.tmdb.org/t/p/original/${state.trending.results[index].posterPath}",
                        );
                      },
                    ),
                  );
                } else if (state is TrendingError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text("Error"));
                }
              },
            );
  }
}