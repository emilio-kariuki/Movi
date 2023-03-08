part of 'movie_details_bloc.dart';

@immutable
abstract class MovieDetailsEvent {}


class GetMovieDetails extends MovieDetailsEvent {
  final int movieId;
  GetMovieDetails({required this.movieId});
}
