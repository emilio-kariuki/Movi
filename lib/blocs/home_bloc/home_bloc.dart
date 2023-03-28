import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movi/models/movie_model.dart';
import 'package:movi/models/trending_model.dart';
import 'package:movi/Repository/repo.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<GetPopular>((event, emit) async {
      emit(HomeLoading());
      try {
        final popular = await Repository.getPopularMovies(page: event.page);
        emit(PopularLoaded(
          popular: popular,
        ));
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    });

    on<GetTopRated>((event, emit) async {
      emit(HomeLoading());
      try {
        final topRated = await Repository.getTopRatedMovies(page: event.page);
        emit(TopRatedLoaded(
          topRated: topRated,
        ));
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    });

    on<GetTrending>((event, emit) async {
      emit(HomeLoading());
      try {
        final trending = await Repository.getTrendingMovies(page: event.page);
        emit(TrendingLoaded(
          trending: trending,
        ));
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    });

    on<GetHome>((event, emit) async {
      emit(HomeLoading());
      try {
        final trending = await Repository.getTrendingMovies(page: event.page);
        final popular = await Repository.getPopularMovies(page: event.page);
        final topRated = await Repository.getTopRatedMovies(page: event.page);

        emit(HomeLoaded(
          topRated: topRated,
          popular: popular,
          trending: trending,
        ));
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    });
  }
}
