import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movistar/UI/Home/Widget/PopularMoviesPage.dart';
import 'package:movistar/UI/Home/Widget/TitleWidget.dart';
import 'package:movistar/UI/Home/Widget/TrendingMoviesPage.dart';
import 'package:movistar/blocs/topRated_bloc/top_rated_bloc.dart';
import 'package:movistar/blocs/trending_bloc/trending_bloc.dart';

import '../../blocs/popular_bloc/popular_bloc.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final movieController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          BlocProvider.of<PopularBloc>(context).add(GetPopular());
          BlocProvider.of<TrendingBloc>(context).add(GetTrending());
        },
        child: const Icon(Icons.refresh),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // search bar
            TextFormField(
              controller: movieController,
              decoration: const InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(
                    color: Colors.black38,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(
                  Icons.search,
                  size: 20,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),

            //carousel slider

            BlocBuilder<TopRatedBloc, TopRatedState>(
              builder: (context, state) {
                if (state is TopRatedInitial) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TopRatedLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TopRatedLoaded) {
                  return CarouselSlider.builder(
                    itemCount: state.topRated.results.length,
                    itemBuilder: (context, index, realIndex) {
                      return CachedNetworkImage(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: MediaQuery.of(context).size.width,
                        imageUrl:
                            "https://image.tmdb.org/t/p/w500${state.topRated.results[index].posterPath}",
                        fit: BoxFit.cover,
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                          ),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 18,
                        ),
                      );
                    },
                    options: CarouselOptions(
                        height: MediaQuery.of(context).size.height * 0.2,
                        enlargeCenterPage: false,
                        viewportFraction: 1,
                        autoPlay: true,
                        onPageChanged: (int i, carouselPageChangedReason) {
                          print(i);
                        }),
                  );
                } else if (state is TopRatedError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text("Error"));
                }
              },
            ),

            const SizedBox(height: 10),

            // Popular Movies

            const TitleMovie(title: "Popular Movies"),
            const PopularMovies(),

            // Trending Movies

            const TitleMovie(title: "Trending Movies"),
            const TrendingMovies(),
          ],
        ),
      )),
    );
  }
}
