part of 'user_bloc.dart';

abstract class UserEvent {}

class GetUser extends UserEvent {
  final int id;
  GetUser({required this.id});
}

class GetUserFilms extends UserEvent {
  final int id;
  GetUserFilms({required this.id});
}
