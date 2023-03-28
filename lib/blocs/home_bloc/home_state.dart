part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class PopularLoaded extends HomeState {
  final MovieModel popular;

  const PopularLoaded({
    required this.popular,
  });

  @override
  List<Object> get props => [
        popular,
      ];
}

class TrendingLoaded extends HomeState {
  final Trending trending;

  const TrendingLoaded({
    required this.trending,
  });

  @override
  List<Object> get props => [
        trending,
      ];
}

class TopRatedLoaded extends HomeState {
  final MovieModel topRated;

  const TopRatedLoaded({
    required this.topRated,
  });

  @override
  List<Object> get props => [
        topRated,
      ];
}

class HomeLoaded extends HomeState {
  final MovieModel topRated;
  final Trending trending;
  final MovieModel popular;

  const HomeLoaded({
    required this.topRated,
    required this.trending,
    required this.popular,
  });

  @override
  List<Object> get props => [
        topRated,
        trending,
        popular,
      ];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
