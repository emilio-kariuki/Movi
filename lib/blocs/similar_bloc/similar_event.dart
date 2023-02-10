part of 'similar_bloc.dart';

@immutable
abstract class SimilarEvent {}


class GetSimilar extends SimilarEvent {
  final int movieId;
  GetSimilar({required this.movieId});
}