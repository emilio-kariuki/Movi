part of 'trailer_bloc.dart';

abstract class TrailerEvent extends Equatable {
  const TrailerEvent();

  @override
  List<Object> get props => [];
}


class GetTrailer extends TrailerEvent {
  final int id;

  const GetTrailer({required this.id});

  @override
  List<Object> get props => [id];
}