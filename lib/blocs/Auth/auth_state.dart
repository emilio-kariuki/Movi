part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoginLoading extends AuthState {}

class AuthLoginSuccess extends AuthState {}

class AuthLoginError extends AuthState {
  final String message;
  const AuthLoginError({required this.message});

  @override
  List<Object> get props => [message];
}

class AuthRegisterLoading extends AuthState {}

class AuthRegisterSuccess extends AuthState {}

class AuthRegisterError extends AuthState {
  final String message;
  const AuthRegisterError({required this.message});

  @override
  List<Object> get props => [message];
}

class AuthLogoutLoading extends AuthState {}

class AuthLogoutSuccess extends AuthState {}

class AuthLogoutError extends AuthState {
  final String message;
  const AuthLogoutError({required this.message});

  @override
  List<Object> get props => [message];
}
