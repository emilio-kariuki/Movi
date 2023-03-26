// ignore_for_file: unnecessary_type_check

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:movi/models/SearchMovieModel.dart';
import 'package:movi/Repository/repo.dart';

part 'search_movie_event.dart';
part 'search_movie_state.dart';

class SearchMovieBloc extends Bloc<SearchMovieEvent, SearchMovieState> {
  SearchMovieBloc() : super(SearchMovieInitial()) {
    on<GetMovie>((event, emit) async {
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
