part of 'game_bloc.dart';


enum GameStatus { initial, success, failure }

class GameState extends Equatable {
  final GameStatus status;
  final List<GamePlayData> games;
  final String? errorMessage;

  const GameState._({
    required this.status,
    this.games = const [],
    this.errorMessage,
  });

  const GameState.initial() : this._(status: GameStatus.initial);

  const GameState.success(List<GamePlayData> games) : this._(status: GameStatus.success, games: games);

  const GameState.failure(String errorMessage) : this._(status: GameStatus.failure, errorMessage: errorMessage);

  @override
  List<Object?> get props => [status, games, errorMessage];
}
