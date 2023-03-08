// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movi/models/GenresModel.dart';
import 'package:movi/Repository/repo.dart';

part 'movie_genre_event.dart';
part 'movie_genre_state.dart';

class MovieGenreBloc extends Bloc<MovieGenreEvent, MovieGenreState> {
  MovieGenreBloc() : super(MovieGenreInitial()) {
    on<MovieGenreEvent>((event, emit) async {
      if (event is GetGenres) {
        emit(MovieGenreLoading());
        try {
          final genres = await Repository.getGenres();
          emit(MovieGenreLoaded(genres));
        } catch (e) {
          emit(MovieGenreError(e.toString()));
        }
      }
    });
  }
}
