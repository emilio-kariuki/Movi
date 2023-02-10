import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:movistar/models/PopularModel.dart';
import 'package:movistar/repo/repo.dart';

part 'popular_event.dart';
part 'popular_state.dart';

class PopularBloc extends Bloc<PopularEvent, PopularState> {
  PopularBloc() : super(PopularInitial()) {
    on<PopularEvent>((event, emit) async {
      if (event is GetPopular) {
        emit(PopularLoading());
        try {
          final popular = await Repository.getPopularMovies(page: event.page);
          
          emit(PopularLoaded(popular));
        } catch (e) {
          emit(PopularError(e.toString()));
        }
      }
    });
  }
}
