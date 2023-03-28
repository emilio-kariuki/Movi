part of 'genre_bloc.dart';

abstract class GenreEvent extends Equatable {
  const GenreEvent();

  @override
  List<Object> get props => [];
}

class MovieGenreFetched extends GenreEvent {
  final int genreId;
  final int page;

  const MovieGenreFetched({required this.page, required this.genreId});

  @override
  List<Object> get props => [genreId, page];
}


class MovieKeywordsFetched extends GenreEvent {
  final int genreId;
  final int page;

  const MovieKeywordsFetched({required this.page, required this.genreId});

  @override
  List<Object> get props => [genreId, page];
}