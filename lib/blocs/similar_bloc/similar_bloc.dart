import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:movistar/models/MovieModel.dart';
import 'package:movistar/Repository/repo.dart';

part 'similar_event.dart';
part 'similar_state.dart';

class SimilarBloc extends Bloc<SimilarEvent, SimilarState> {
  SimilarBloc() : super(SimilarInitial()) {
    on<SimilarEvent>((event, emit) async {
      if (event is GetSimilar) {
        emit(SimilarLoading());
        try {
          final similar = await Repository.getMovieSimilar(id: event.movieId);
          debugPrint("Similar: ${similar.results.length}");
          emit(SimilarLoaded(similar));
        } catch (e) {
          emit(SimilarError(e.toString()));
        }
      }
    });
  }
}
