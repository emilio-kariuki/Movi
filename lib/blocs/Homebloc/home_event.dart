// ignore_for_file: must_be_immutable

part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetPopular extends HomeEvent {
  int page = 1;
  GetPopular({required this.page});
}

class GetTrending extends HomeEvent {
  int page = 1;
  GetTrending({required this.page});
}

class GetTopRated extends HomeEvent {
  int page = 1;
  GetTopRated({required this.page});
}

class GetHome extends HomeEvent {
  int page = 1;
  GetHome({required this.page});
}
