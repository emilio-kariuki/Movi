part of 'genre_bloc.dart';

abstract class GenreState extends Equatable {
  const GenreState();
  
  @override
  List<Object> get props => [];
}

class GenreInitial extends GenreState {}

class GenreLoading extends GenreState {}

class GenreLoaded extends GenreState {
  final MovieModel genres;

  const GenreLoaded({required this.genres});

  @override
  List<Object> get props => [genres];
}

class GenreError extends GenreState {
  final String message;

  const GenreError({required this.message});

  @override
  List<Object> get props => [message];
}

class KeywordsInitial extends GenreState {}

class KeywordsLoading extends GenreState {}

class KeywordsLoaded extends GenreState {
  final MovieModel keywords;

  const KeywordsLoaded({required this.keywords});

  @override
  List<Object> get props => [keywords];
}

class KeywordsError extends GenreState {
  final String message;

  const KeywordsError({required this.message});

  @override
  List<Object> get props => [message];
}

