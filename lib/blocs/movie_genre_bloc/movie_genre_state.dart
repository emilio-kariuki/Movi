part of 'movie_genre_bloc.dart';

@immutable
abstract class MovieGenreState {}

class MovieGenreInitial extends MovieGenreState {}

class MovieGenreLoading extends MovieGenreState {}

class MovieGenreLoaded extends MovieGenreState {
  final Genres genre;

  MovieGenreLoaded(this.genre);
}

class MovieGenreError extends MovieGenreState {
  final String message;

  MovieGenreError(this.message);
}
