import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movi/Repository/repo.dart';
import 'package:movi/models/search_movie_model.dart';

part 'search_movie_event.dart';
part 'search_movie_state.dart';

class SearchMovieBloc extends Bloc<SearchMovieEvent, SearchMovieState> {
  SearchMovieBloc() : super(SearchMovieInitial()) {
    on<GetMovie>((event, emit) async {
      // ignore: unnecessary_type_check
      if (event is GetMovie) {
        emit(Searching());
        try {
          final search = await Repository.getSearchMovie(
              title: event.title, page: event.page);
          print("SearchMovieBloc: ${search.results.length}");
          emit(SearchMovieSuccess(search: search));
        } catch (e) {
          emit(SearchMovieFail(e.toString()));
        }
      }
    });
  }
}
