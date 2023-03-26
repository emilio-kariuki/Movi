import 'package:flutter/material.dart';
import 'package:movi/UI/widget/movie_widget.dart';
import 'package:movi/models/SearchMovieModel.dart';

class SearchDesignPage extends StatelessWidget {
  const SearchDesignPage({super.key, required this.movie, required this.pop});

  final SearchModel movie;
  final bool pop;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GridView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: (movie.results.length),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        return MoviesWidget(
            title: movie.results[index].title ?? "",
            posterPath: movie.results[index].posterPath ?? "",
            id: movie.results[index].id);
      },
    );
  }
}
