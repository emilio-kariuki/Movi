part of 'popular_bloc.dart';

@immutable
abstract class PopularState {}

class PopularInitial extends PopularState {
  PopularInitial();
}

class PopularLoading extends PopularState {
  PopularLoading();

}

class PopularLoaded extends PopularState {
  final Popular popular;

  PopularLoaded(this.popular);
}

class PopularError extends PopularState {
  final String message;

  PopularError(this.message);
}
