import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:movistar/blocs/trending_bloc/trending_bloc.dart';
import 'package:movistar/models/TopRatedModel.dart';
import 'package:movistar/repo/repo.dart';

part 'top_rated_event.dart';
part 'top_rated_state.dart';

class TopRatedBloc extends Bloc<TopRatedEvent, TopRatedState> {
  TopRatedBloc() : super(TopRatedInitial()) {
    on<TopRatedEvent>((event, emit) async {
      if (event is GetTopRated) {
        emit(TopRatedLoading());
        try {
          final topRated = await Repository.getTopRatedMovies(page: event.page);
          emit(TopRatedLoaded(topRated));
        } catch (e) {
          emit(TopRatedError(e.toString()));
        }
      }
    });
  }
}
