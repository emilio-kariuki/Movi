import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movi/models/MovieCastsModel.dart';
import 'package:movi/models/UserFilmsModel.dart';
import 'package:movi/models/CastModel.dart';
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
