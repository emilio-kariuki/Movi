import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movistar/models/GenreMovieModel.dart';
import 'package:movistar/repo/repo.dart';

part 'genre_bloc_event.dart';
part 'genre_bloc_state.dart';

class GenreBlocBloc extends Bloc<GenreBlocEvent, GenreBlocState> {
  GenreBlocBloc() : super(GenreBlocInitial()) {
    on<GenreBlocEvent>((event, emit) async{
     if(event is GetGenre){
       emit(GenreLoading());
       try{
         final genre = await Repository.getGenreMovies(genre: event.genreId, page: 1);
         emit(GenreLoaded(genre));
       }catch(e){
         emit(GenreError(e.toString()));
       }
     }
    });
  }
}
