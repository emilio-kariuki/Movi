import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movistar/UI/Home/Widget/CarouselImage.dart';
import 'package:movistar/UI/Home/Widget/CarouselWidgetPage.dart';
import 'package:movistar/UI/Home/Widget/GenreMoviesPage.dart';
import 'package:movistar/UI/Home/Widget/PopularMoviesPage.dart';
import 'package:movistar/UI/Home/Widget/TitleWidget.dart';
import 'package:movistar/UI/Home/Widget/TopRatedMoviesPage.dart';
import 'package:movistar/UI/Home/Widget/TrendingMoviesPage.dart';
import 'package:movistar/blocs/genre_bloc/genre_bloc_bloc.dart';
import 'package:movistar/blocs/movieGenre_bloc/movie_genre_bloc.dart';
import 'package:movistar/blocs/topRated_bloc/top_rated_bloc.dart';
import 'package:movistar/blocs/trending_bloc/trending_bloc.dart';

import '../../blocs/popular_bloc/popular_bloc.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  final movieController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    int page = Random().nextInt(300);
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          int page = Random().nextInt(300);

          BlocProvider.of<PopularBloc>(context).add(GetPopular(page));
          BlocProvider.of<TrendingBloc>(context).add(GetTrending(page));
          BlocProvider.of<TopRatedBloc>(context).add(GetTopRated(page));
          BlocProvider.of<TopRatedBloc>(context).add(GetTopRated(page));
          BlocProvider.of<GenreBlocBloc>(context).add(GetGenre(page));
        },
        child: const Icon(Icons.refresh),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            int page = Random().nextInt(300);
            BlocProvider.of<PopularBloc>(context).add(GetPopular(page));
            BlocProvider.of<TrendingBloc>(context).add(GetTrending(page));
            BlocProvider.of<TopRatedBloc>(context).add(GetTopRated(page));
            BlocProvider.of<TopRatedBloc>(context).add(GetTopRated(page));
            BlocProvider.of<GenreBlocBloc>(context).add(GetGenre(page));
          },
          child: SingleChildScrollView(
            // physics: const CustomPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // search bar
                  // TextFormField(
                  //   controller: movieController,
                  //   decoration: const InputDecoration(
                  //     hintText: "Search",
                  //     hintStyle: TextStyle(
                  //         color: Colors.black38,
                  //         fontSize: 15,
                  //         fontWeight: FontWeight.w500),
                  //     filled: true,
                  //     fillColor: Colors.white,
                  //     prefixIcon: Icon(
                  //       Icons.search,
                  //       size: 20,
                  //       color: Colors.grey,
                  //     ),
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.all(
                  //         Radius.circular(15),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Hello",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w500),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 22,
                            ))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  const CarouselWidget(),

                  //carousel slider

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                         SizedBox(height: 10),

                        // Popular Movies

                         TitleMovie(title: "Popular Movies"),
                         PopularMovies(),
                        //top rated

                         TitleMovie(title: "Top Rated Movies"),
                         TopRatedMovies(),

                        // Trending Movies

                         TitleMovie(title: "Trending Movies"),
                         TrendingMovies(),

                         TitleMovie(title: "All Genres"),
                        GenreMovie(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomPhysics extends ScrollPhysics {
  const CustomPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  CustomPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomPhysics(parent: buildParent(ancestor));
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 150,
        stiffness: 200,
        damping: 1,
      );
}
