part of 'trending_bloc.dart';

@immutable
abstract class TrendingState {}

class TrendingInitial extends TrendingState {}

class TrendingLoading extends TrendingState {
  TrendingLoading();

}

class TrendingLoaded extends TrendingState {
  final Trending trending;

  TrendingLoaded(this.trending);
}

class TrendingError extends TrendingState {
  final String message;

  TrendingError(this.message);
}
