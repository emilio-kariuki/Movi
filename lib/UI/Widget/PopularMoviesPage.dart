import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movistar/UI/Widget/MovieWidget.dart';

import 'package:movistar/models/MovieModel.dart';

class PopularMovies extends StatelessWidget {
  final MovieModel state;
  const PopularMovies({super.key, required this.state});

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
