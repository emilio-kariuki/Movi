part of 'movie_genre_bloc.dart';

@immutable
abstract class MovieGenreEvent {}

class GetGenres extends MovieGenreEvent {
  GetGenres();
}
