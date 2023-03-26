import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movi/models/cast_model.dart';
import 'package:movi/models/user_films_model.dart';
import 'package:movi/Repository/repo.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<UserEvent>((event, emit) async {
      if (event is GetUser) {
        emit(UserLoading());
        try {
          await Repository.getUser(id: event.id).then((user) async {
            await Repository.getUserFilms(id: event.id).then((userFilms) {
              emit(UserLoaded(user, userFilms));
            });
          });
        } catch (e) {
          emit(UserError(e.toString()));
        }
      }
    });
  }
}
