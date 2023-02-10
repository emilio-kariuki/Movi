part of 'top_rated_bloc.dart';

@immutable
abstract class TopRatedState {}

class TopRatedInitial extends TopRatedState {
  TopRatedInitial();
}

class TopRatedLoading extends TopRatedState {
  TopRatedLoading();
}

class TopRatedLoaded extends TopRatedState {
  final TopRated topRated;
  TopRatedLoaded(this.topRated);
}

class TopRatedError extends TopRatedState {
  final String message;

  TopRatedError(this.message);
}
