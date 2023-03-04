import 'package:flutter/material.dart';
import 'package:movistar/UI/Widget/MovieWidget.dart';
import '../../../models/GenreMovieModel.dart';



class GenreMovies extends StatelessWidget {
  final GenreMovie state;
  const GenreMovies({
    super.key, required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
            height: MediaQuery.of(context).size.width > 900
                ? MediaQuery.of(context).size.height * 0.4
                : MediaQuery.of(context).size.height * 0.27,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.items.length,
              itemBuilder: (context, index) {
                return MoviesWidget(
                  id: state.items[index].id,
                  title: state.items[index].title,
                  posterPath:
                      "https://image.tmdb.org/t/p/original/${state.items[index].posterPath}",
                );
              },
            ),
          );
  }
}
