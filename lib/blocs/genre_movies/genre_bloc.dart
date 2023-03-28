import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movi/Repository/repo.dart';
import 'package:movi/models/movie_model.dart';

part 'genre_event.dart';
part 'genre_state.dart';

class GenreBloc extends Bloc<GenreEvent, GenreState> {
  GenreBloc() : super(GenreInitial()) {
    on<MovieGenreFetched>((event, emit) async {
      emit(GenreLoading());
      try {
        final genres = await Repository.getMoviesInGenre(
            id: event.genreId, page: event.page);
        emit(GenreLoaded(genres: genres));
      } catch (e) {
        emit(GenreError(message: e.toString()));
      }
    });

    on<MovieKeywordsFetched>((event, emit) async {
      emit(KeywordsLoading());
      try {
        final keywords = await Repository.getMoviesInKeywords(
            id: event.genreId, page: event.page);
        emit(KeywordsLoaded(keywords: keywords));
      } catch (e) {
        emit(KeywordsError(message: e.toString()));
      }
    });
  }
}
