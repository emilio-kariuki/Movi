part of 'genre_bloc_bloc.dart';

@immutable
abstract class GenreBlocState {}

class GenreBlocInitial extends GenreBlocState {

}

class GenreLoading extends GenreBlocState {
  GenreLoading();
}

class GenreLoaded extends GenreBlocState {
  final GenreMovie genreList;
  GenreLoaded(this.genreList);
}

class GenreError extends GenreBlocState {
  final String message;
  GenreError(this.message);
}