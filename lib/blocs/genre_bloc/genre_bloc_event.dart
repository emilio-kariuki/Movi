part of 'genre_bloc_bloc.dart';

@immutable
abstract class GenreBlocEvent {}

class GetGenre extends GenreBlocEvent {
  int genreId = 9648;
  GetGenre(this.genreId);
  
  
}
