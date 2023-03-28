// ignore_for_file: avoid_print

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movi/Repository/repo.dart';
import 'package:movi/models/movie_trailer.dart';

part 'trailer_event.dart';
part 'trailer_state.dart';

class TrailerBloc extends Bloc<TrailerEvent, TrailerState> {
  TrailerBloc() : super(TrailerInitial()) {
    on<GetTrailer>((event, emit) async {
      emit(TrailerLoading());
      try {
        final trailer = await Repository.getMovieTrailers(id: event.id);
        emit(TrailerLoaded(trailer: trailer));
      } catch (e) {
        print(e);
        emit(TrailerError(message: e.toString()));
      }
    });
  }
}
