// ignore_for_file: must_be_immutable

part of 'popular_bloc.dart';

@immutable
abstract class PopularEvent {}

class GetPopular extends PopularEvent {
  int page = 1;
  GetPopular(this.page);
}

class GetNextPage extends PopularEvent {
  GetNextPage();
}
