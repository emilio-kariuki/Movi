import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movistar/models/TrendingModel.dart';
import 'package:movistar/Repository/repo.dart';

import '../../models/GenreMovieModel.dart';
import '../../models/MovieModel.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<GetHome>(
      (event, emit) async {
        emit(HomeLoading());
        try {
          final trending = await Repository.getTrendingMovies(page: event.page);
          final topRated = await Repository.getTopRatedMovies(page: event.page);
          final popular = await Repository.getPopularMovies(page: event.page);
          final genre = await Repository.getGenreMovies(page: event.page);
          emit(HomeLoaded(
            trending: trending,
            topRated: topRated,
            popular: popular,
            genreList: genre,
          ));
        } catch (e) {
          emit(HomeError(e.toString()));
        }
      },
    );
  }
}
