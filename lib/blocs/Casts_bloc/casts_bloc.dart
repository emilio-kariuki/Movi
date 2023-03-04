import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movistar/models/MovieCastsModel.dart';
import 'package:movistar/Repository/repo.dart';

part 'casts_event.dart';
part 'casts_state.dart';

class CastsBloc extends Bloc<CastsEvent, CastsState> {
  CastsBloc() : super(CastsInitial()) {
    on<CastsEvent>((event, emit) async{
      if (event is GetCasts) {
        emit(CastsLoading());
        try {
          final casts = await Repository.getMovieCasts(id: event.movieId);
          emit(CastsLoaded(casts));
        } catch (e) {
          emit(CastsError(e.toString()));
        }
      }
    });
  }
}
