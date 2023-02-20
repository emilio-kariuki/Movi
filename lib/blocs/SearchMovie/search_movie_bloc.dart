// ignore_for_file: unnecessary_type_check

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:movistar/models/SearchMovieModel.dart';
import 'package:movistar/repo/repo.dart';

part 'search_movie_event.dart';
part 'search_movie_state.dart';

class SearchMovieBloc extends Bloc<SearchMovieEvent, SearchMovieState> {
  SearchMovieBloc() : super(SearchMovieInitial()) {
    on<SearchInitiated>((event, emit) async {
      if(event is SearchInitiated){
        emit(Searching());
        try {
          final search = await Repository.getSearchMovie(title: event.title);
          print("Search is $search");
          emit(SearchMovieSuccess(search: search));
        } catch (e) {
          emit(SearchMovieFail(e.toString()));
        }
      }
      
    });
  }
}
