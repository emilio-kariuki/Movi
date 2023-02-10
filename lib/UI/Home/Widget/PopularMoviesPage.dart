import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movistar/UI/Home/Widget/MovieWidget.dart';
import 'package:movistar/blocs/popular_bloc/popular_bloc.dart';

class PopularMovies extends StatelessWidget {
  const PopularMovies({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PopularBloc, PopularState>(
              builder: (context, state) {
                if (state is PopularInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PopularLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PopularLoaded) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.26,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.popular.results.length,
                      itemBuilder: (context, index) {
                        return MoviesWidget(
                                                    id: state.popular.results[index].id,

                          title: state.popular.results[index].title,
                          posterPath:
                              "https://image.tmdb.org/t/p/original/${state.popular.results[index].posterPath}",
                        );
                      },
                    ),
                  );
                } else if (state is PopularError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text("Error"));
                }
              },
            );
  }
}