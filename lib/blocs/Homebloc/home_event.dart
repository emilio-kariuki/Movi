part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class GetHome extends HomeEvent {
  int page = 1;
  GetHome({required this.page});
}