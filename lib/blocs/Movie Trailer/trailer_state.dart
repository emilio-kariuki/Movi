part of 'trailer_bloc.dart';

abstract class TrailerState extends Equatable {
  const TrailerState();
  
  @override
  List<Object> get props => [];
}

class TrailerInitial extends TrailerState {}

class TrailerLoading extends TrailerState {}

class TrailerLoaded extends TrailerState {
  final Trailer trailer;

  const TrailerLoaded({required this.trailer});

  @override
  List<Object> get props => [trailer];
}

class TrailerError extends TrailerState {
  final String message;

  const TrailerError({required this.message});

  @override
  List<Object> get props => [message];
}
