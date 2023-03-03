part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final MovieModel popular;
  final MovieModel topRated;
  final Trending trending;
  final GenreMovie genreList;

  const HomeLoaded(
      {required this.popular,
      required this.topRated,
      required this.trending,
      required this.genreList});

  @override
  List<Object> get props => [popular, topRated, trending, genreList];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
