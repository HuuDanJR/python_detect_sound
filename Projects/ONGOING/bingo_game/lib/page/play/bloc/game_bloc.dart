import 'package:bingo_game/APIs/service_api.dart';
import 'package:bingo_game/model/gameplay.dart';
import 'package:bingo_game/page/game/left/export.dart';
import 'package:equatable/equatable.dart';

part 'game_state.dart';
part 'game_event.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final service_api = ServiceAPIs();
  GameBloc() : super(const GameState.initial()) {
    on<FetchGames>(_onFetchGames);
     // Add this line to handle RefreshGames
  }


 Future<void> _onFetchGames(FetchGames event, Emitter<GameState> emit) async {
    emit(const GameState.initial());
    try {
      final GamePlay games = await service_api.listGamePlayed();
      debugPrint('_onFetchGames ${games.data.length} ');
      if (games.data.isNotEmpty) {
        emit(GameState.success(games.data));
      } else {
        emit(const GameState.failure('Failed to fetch games'));
      }
    } catch (e) {
      emit(GameState.failure('Failed to fetch history or no history found '));
    }
  }
}
