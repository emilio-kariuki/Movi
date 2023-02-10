part of 'movie_genre_bloc.dart';

@immutable
abstract class MovieGenreState {}

class MovieGenreInitial extends MovieGenreState {}

class MovieGenreLoading extends MovieGenreState {}

class MovieGenreLoaded extends MovieGenreState {
  final MovieGenre movieGenre;

  MovieGenreLoaded(this.movieGenre);
}

class MovieGenreError extends MovieGenreState {
  final String message;

  MovieGenreError(this.message);
}
