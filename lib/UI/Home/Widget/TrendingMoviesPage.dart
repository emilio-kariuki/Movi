import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movistar/UI/Home/Widget/LoadingMovieShimmer.dart';
import 'package:movistar/UI/Home/Widget/MovieWidget.dart';
import 'package:movistar/models/TrendingModel.dart';


class TrendingMovies extends StatelessWidget {
  final Trending state;
  const TrendingMovies({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
            height: MediaQuery.of(context).size.width > 900
                ? MediaQuery.of(context).size.height * 0.4
                : MediaQuery.of(context).size.height * 0.27,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.results.length,
              itemBuilder: (context, index) {
                return MoviesWidget(
                  id: state.results[index].id,
                  title: state.results[index].title ?? "unknown",
                  posterPath:
                      "https://image.tmdb.org/t/p/original/${state.results[index].posterPath}",
                );
              },
            ),
          );
  }
}
