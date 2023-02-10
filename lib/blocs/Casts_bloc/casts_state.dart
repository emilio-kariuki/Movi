part of 'casts_bloc.dart';

@immutable
abstract class CastsState {}

class CastsInitial extends CastsState {}

class CastsLoading extends CastsState {}

class CastsLoaded extends CastsState {
  final Cast casts;
  CastsLoaded(this.casts);
}

class CastsError extends CastsState {
  final String message;

  CastsError(this.message);
}
