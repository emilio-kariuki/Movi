import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movi/Repository/AuthRepository.dart';
import 'package:movi/Util/SharedPreferencesManager.dart';
import 'package:movi/blocs/Authentication/authentication_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
      {required this.authenticationBloc,
      required this.authRepo,
      required this.sharedPreferenceManager})
      : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is LoginButtonPressed) {
        emit(AuthLoginLoading());

        try {
          final isLoggedIn = await authRepo.loginUser(
              email: event.email, password: event.password);

          if (isLoggedIn) {
            authenticationBloc.add(LoggedIn());
            await sharedPreferenceManager.setLoginStatus(status: isLoggedIn);
            emit(AuthLoginSuccess());
          } else {
            emit(const AuthLoginError(message: 'login failed'));
          }
        } catch (e) {
          emit(const AuthLoginError(message: "login failed"));
        }
      }

      if (event is RegisterButtonPressed) {
        emit(AuthRegisterLoading());

        try {
          final isLoggedIn = await authRepo.registerUser(
              name: event.name, email: event.email, password: event.password);

          if (isLoggedIn) {
            authenticationBloc.add(LoggedIn());
            await sharedPreferenceManager.setLoginStatus(status: isLoggedIn);
            emit(AuthRegisterSuccess());
          } else {
            emit(const AuthRegisterError(message: 'registration failed'));
          }
        } catch (e) {
          emit(const AuthRegisterError(message: 'registration failed'));
        }
      }
    });
  }

  final AuthRepo authRepo;
  final AuthenticationBloc authenticationBloc;
  final SharedPreferenceManager sharedPreferenceManager;
}
