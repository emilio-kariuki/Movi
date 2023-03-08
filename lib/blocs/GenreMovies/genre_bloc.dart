import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movi/Repository/repo.dart';
import 'package:movi/models/MovieModel.dart';

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
  }
}
