part of 'casts_bloc.dart';

@immutable
abstract class CastsEvent {}

class GetCasts extends CastsEvent {
  final int movieId;
  GetCasts({required this.movieId});
}


