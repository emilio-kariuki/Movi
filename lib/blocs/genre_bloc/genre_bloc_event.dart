part of 'genre_bloc_bloc.dart';

@immutable
abstract class GenreBlocEvent {}

class GetGenre extends GenreBlocEvent {
  int page = 1;
  GetGenre(this.page);
  
  
}
