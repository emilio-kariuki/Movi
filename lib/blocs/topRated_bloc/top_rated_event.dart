part of 'top_rated_bloc.dart';

@immutable
abstract class TopRatedEvent {}

class GetTopRated extends TopRatedEvent {
  int page = 1;

  GetTopRated();
}

class GetNextPage extends TopRatedEvent {
  int page = 2;

  GetNextPage();
}
