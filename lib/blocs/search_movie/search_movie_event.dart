part of 'search_movie_bloc.dart';

abstract class SearchMovieEvent extends Equatable {
  const SearchMovieEvent();

  @override
  List<Object> get props => [];
}

class GetMovie extends SearchMovieEvent {
  final String title;
  int page = 1;

   GetMovie({required this.title, required this.page});

  @override
  List<Object> get props => [title];
}
