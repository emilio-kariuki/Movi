// ignore_for_file: must_be_immutable

part of 'popular_bloc.dart';

@immutable
abstract class PopularEvent {}

class GetPopular extends PopularEvent {
  int page = PopularLoading().page + 1 ;


  GetPopular();
}

class GetNextPage extends PopularEvent {
  int page = PopularLoading().page + 2;

  GetNextPage();
}

