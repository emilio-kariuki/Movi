import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movi/models/movie_model.dart';
import 'package:movi/Repository/repo.dart';

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
