part of 'movie_genre_bloc.dart';

@immutable
abstract class MovieGenreEvent {}

class GetMovieGenre extends MovieGenreEvent {
  GetMovieGenre();
}
