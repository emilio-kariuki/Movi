import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movi/UI/widget/carousel_image.dart';
import 'package:movi/blocs/home_bloc/home_bloc.dart';

class CarouselWidget extends StatelessWidget {
  const CarouselWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HomeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HomeLoaded) {
          return CarouselSlider.builder(
            itemCount: state.trending.results.length,
            itemBuilder: (context, index, realIndex) {
              return Row(
                children: [
                  CarouselImage(
                    id: state.trending.results[index].id,
                    width: MediaQuery.of(context).size.width,
                    path: state.trending.results[index].posterPath ?? "",
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  CarouselImage(
                    id: state
                        .trending
                        .results[((index + 1) < state.trending.results.length)
                            ? (index + 1)
                            : (state.trending.results.length - 3)]
                        .id,
                    width: MediaQuery.of(context).size.width * 0.55,
                    path: state
                            .trending
                            .results[((index + 1) <
                                    state.trending.results.length - 1)
                                ? (index + 1)
                                : (state.trending.results.length - 4)]
                            .posterPath ??
                        "",
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  CarouselImage(
                      id: state
                          .trending
                          .results[
                              ((index + 2) < state.trending.results.length - 2)
                                  ? (index + 2)
                                  : (state.trending.results.length - 5)]
                          .id,
                      width: MediaQuery.of(context).size.width,
                      path: state
                              .trending
                              .results[((index + 2) <
                                      state.trending.results.length - 2)
                                  ? (index + 2)
                                  : (state.trending.results.length - 5)]
                              .posterPath ??
                          ""),
                ],
              );
            },
            options: CarouselOptions(
                enlargeFactor: 0.3,
                height: MediaQuery.of(context).size.width > 900
                    ? MediaQuery.of(context).size.height * 0.5
                    : MediaQuery.of(context).size.height * 0.2,
                enlargeCenterPage: true,
                // viewportFraction: 2,
                autoPlayAnimationDuration: const Duration(seconds: 1),
                autoPlay: true,
                onPageChanged: (int i, carouselPageChangedReason) {}),
          );
        } else if (state is HomeError) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text("Error"));
        }
      },
    );
  }
}
