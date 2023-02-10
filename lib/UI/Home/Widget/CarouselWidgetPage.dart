import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movistar/UI/Home/Widget/CarouselImage.dart';
import 'package:movistar/blocs/topRated_bloc/top_rated_bloc.dart';

class CarouselWidget extends StatelessWidget {
  const CarouselWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopRatedBloc, TopRatedState>(
      builder: (context, state) {
        if (state is TopRatedInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TopRatedLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TopRatedLoaded) {
          return CarouselSlider.builder(
            itemCount: state.topRated.results.length,
            itemBuilder: (context, index, realIndex) {
              return Row(
                children: [
                  CarouselImage(
                    width: MediaQuery.of(context).size.width,
                    path: state.topRated.results[index].posterPath,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  CarouselImage(
                    width: MediaQuery.of(context).size.width * 0.55,
                    path: state
                        .topRated
                        .results[
                            ((index + 1) < state.topRated.results.length - 1)
                                ? (index + 1)
                                : (state.topRated.results.length - 1)]
                        .posterPath,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  CarouselImage(
                      width: MediaQuery.of(context).size.width,
                      path: state
                          .topRated
                          .results[
                              ((index + 2) < state.topRated.results.length - 1)
                                  ? (index + 2)
                                  : (state.topRated.results.length - 1)]
                          .posterPath)
                ],
              );
            },
            options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.2,
                enlargeCenterPage: false,
                viewportFraction: 2,
                autoPlayAnimationDuration: const Duration(seconds: 1),
                autoPlay: true,
                onPageChanged: (int i, carouselPageChangedReason) {}),
          );
        } else if (state is TopRatedError) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text("Error"));
        }
      },
    );
  }
}
