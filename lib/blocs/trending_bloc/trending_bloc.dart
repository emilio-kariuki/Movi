import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movistar/models/TrendingModel.dart';
import 'package:movistar/repo/repo.dart';

part 'trending_event.dart';
part 'trending_state.dart';

class TrendingBloc extends Bloc<TrendingEvent, TrendingState> {
  TrendingBloc() : super(TrendingInitial()) {
    on<TrendingEvent>((event, emit) async{
      if(event is GetTrending){
       emit(TrendingLoading());
        try {
          final trending = await Repository.getTrendingMovies();
          emit(TrendingLoaded(trending));
        } catch (e) {
          emit(TrendingError(e.toString()));
        }
      }
    });
  }
}
