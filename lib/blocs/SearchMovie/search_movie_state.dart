part of 'search_movie_bloc.dart';

@immutable
abstract class SearchMovieState extends Equatable {
  const SearchMovieState();

  @override
  List<Object> get props => [];
}

class SearchMovieInitial extends SearchMovieState {}


class Searching extends SearchMovieState {}

class SearchMovieSuccess extends SearchMovieState {
  final SearchModel search;

  const SearchMovieSuccess({required this.search});

  @override
  List<Object> get props => [search];
}

class SearchMovieFail extends SearchMovieState {
  final String message;

  const SearchMovieFail(this.message);

  @override
  List<Object> get props => [message];
}
