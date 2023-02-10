part of 'similar_bloc.dart';

@immutable
abstract class SimilarState {}

class SimilarInitial extends SimilarState {}

class SimilarLoading extends SimilarState {}

class SimilarLoaded extends SimilarState {
  final Similar similar;
  SimilarLoaded(this.similar);
}

class SimilarError extends SimilarState {
  final String message;

  SimilarError(this.message);
}

