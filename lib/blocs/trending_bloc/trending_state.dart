part of 'trending_bloc.dart';

@immutable
abstract class TrendingState {}

class TrendingInitial extends TrendingState {
  TrendingInitial();
  
}

class TrendingLoading extends TrendingState {}

class TrendingLoaded extends TrendingState {
  final Trending trending;

  TrendingLoaded(this.trending);
}

class TrendingError extends TrendingState {
  final String message;

  TrendingError(this.message);
}
