part of 'user_bloc.dart';

abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final CastModel user;
  final UserFilms userFilms;
  UserLoaded(this.user, this.userFilms);
}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}
