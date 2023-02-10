part of 'trending_bloc.dart';

@immutable
abstract class TrendingEvent {}

class GetTrending extends TrendingEvent {
  int page = 1;

  GetTrending(this.page);
}

class GetNextPage extends TrendingEvent {
  int page = 1;

  GetNextPage(this.page);
}
