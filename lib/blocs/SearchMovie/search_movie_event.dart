part of 'search_movie_bloc.dart';

@immutable
abstract class SearchMovieEvent extends Equatable {
  const SearchMovieEvent();

  @override
  List<Object> get props => [];
}


class SearchInitiated extends SearchMovieEvent {
  final String title;

  const SearchInitiated({required this.title});

  @override
  List<Object> get props => [title];
}
