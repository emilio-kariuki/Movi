import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:movi/models/KeywordsModel.dart';
import 'package:movi/models/MovieDetailsModel.dart';
import 'package:movi/Repository/repo.dart';
import 'package:movi/models/ReviewModel.dart';

part 'movie_details_event.dart';
part 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  MovieDetailsBloc() : super(MovieDetailsInitial()) {
    on<MovieDetailsEvent>(
      (event, emit) async {
        if (event is GetMovieDetails) {
          emit(MovieDetailsLoading());
          try {
            final movieDetails =
                await Repository.getMovieDetails(id: event.movieId);
            final moviekeywords =
                await Repository.getMovieKeywords(id: event.movieId);
            final movierReviews =
                await Repository.getMovieReviews(id: event.movieId);

            emit(
                MovieDetailsLoaded(movieDetails, moviekeywords, movierReviews));
          } catch (e) {
            print(e);
            emit(MovieDetailsError(e.toString()));
          }
        }
      },
    );
  }
}
