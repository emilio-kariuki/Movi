part of 'trending_bloc.dart';

@immutable
abstract class TrendingEvent {}

class GetTrending extends TrendingEvent {}

class GetNextPage extends TrendingEvent {
  final int page;

  GetNextPage(this.page);
}
