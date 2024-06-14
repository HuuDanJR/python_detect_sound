part of 'game_bloc.dart';
abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

class FetchGames extends GameEvent {}

class UpdateGame extends GameEvent {
  final String id;
  final List<List<int>> round;

  const UpdateGame(this.id, this.round);

  @override
  List<Object> get props => [id, round];
}