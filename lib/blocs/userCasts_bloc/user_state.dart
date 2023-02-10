part of 'user_bloc.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;
  final UserFilms userFilms;
  UserLoaded(this.user, this.userFilms);
}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}
