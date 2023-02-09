import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movistar/UI/Home/Widget/MovieWidget.dart';
import 'package:movistar/blocs/genre_bloc/genre_bloc_bloc.dart';
import 'package:movistar/blocs/trending_bloc/trending_bloc.dart';

class GenreMovie extends StatelessWidget {
  const GenreMovie({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GenreBlocBloc, GenreBlocState>(
              builder: (context, state) {
                if (state is GenreBlocInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GenreLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GenreLoaded) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.26,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.genreList.items.length,
                      itemBuilder: (context, index) {
                        return MoviesWidget(
                          title:
                              state.genreList.items[index].title,
                          posterPath:
                              "https://image.tmdb.org/t/p/original/${state.genreList.items[index].posterPath}",
                        );
                      },
                    ),
                  );
                } else if (state is GenreError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text("Error"));
                }
              },
            );
  }
}