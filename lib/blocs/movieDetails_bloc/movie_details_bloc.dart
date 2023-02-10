import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movistar/models/MovieDetailsModel.dart';
import 'package:movistar/repo/repo.dart';

part 'movie_details_event.dart';
part 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  
  MovieDetailsBloc() : super(MovieDetailsInitial()) {
    on<MovieDetailsEvent>((event, emit) async {
      if (event is GetMovieDetails) {
        emit(MovieDetailsLoading());
        try {
          final movieDetails =
              await Repository.getMovieDetails(id: event.movieId);
          emit(MovieDetailsLoaded(movieDetails));
        } catch (e) {
          emit(MovieDetailsError(e.toString()));
        }
      }
      
    },
    
    );
  }
}
