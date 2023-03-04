import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movistar/models/MovieGenreModel.dart';
import 'package:movistar/Repository/repo.dart';

part 'movie_genre_event.dart';
part 'movie_genre_state.dart';

class MovieGenreBloc extends Bloc<MovieGenreEvent, MovieGenreState> {
  MovieGenreBloc() : super(MovieGenreInitial()) {
    on<MovieGenreEvent>((event, emit) async{
      if (event is GetMovieGenre) {
        emit(MovieGenreLoading());
        try {
          final movieGenre =
              await Repository.getMovieGenre();
          emit(MovieGenreLoaded(movieGenre));
        } catch (e) {
          emit(MovieGenreError(e.toString()));
        }
      }
      
    });
  }
}
