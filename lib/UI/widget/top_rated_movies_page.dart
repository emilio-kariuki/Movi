import 'package:flutter/material.dart';
import 'package:movi/UI/widget/movie_widget.dart';
import 'package:movi/models/movie_model.dart';

class TopRatedMovies extends StatelessWidget {
  final MovieModel state;
  const TopRatedMovies({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.width > 900
          ? MediaQuery.of(context).size.height * 0.4
          : MediaQuery.of(context).size.height * 0.27,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: state.results.length,
        itemBuilder: (context, index) {
          return MoviesWidget(
            voteAverage: state.results[index].voteAverage,
            id: state.results[index].id,
            title: state.results[index].title ?? "",
            posterPath:
                "https://image.tmdb.org/t/p/original/${state.results[index].posterPath}",
          );
        },
      ),
    );
  }
}
