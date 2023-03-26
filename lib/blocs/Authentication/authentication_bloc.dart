// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movi/util/shared_preferences_manager.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc() : super(AuthenticationUnitialized()) {
    on<AuthenticationEvent>(
      (event, emit) async {
        if (event is AppStarted) {
          emit(AuthenticationLoading());
          final isLoggedIn = await SharedPreferenceManager().isLoggedIn();
          if (isLoggedIn) {
            emit(AuthenticationAuthenticated());
          } else {
            emit(AuthenticationUnauthenticated());
          }
        }

        if (event is LoggedIn) {
          emit(AuthenticationLoading());
          await Future.delayed(const Duration(seconds: 1));
          emit(AuthenticationAuthenticated());
        }

        if (event is LoggedOut) {
          emit(AuthenticationLoading());
          await Future.delayed(const Duration(seconds: 1));
          emit(AuthenticationUnauthenticated());
        }
      },
    );
  }
}
