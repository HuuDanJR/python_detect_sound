import 'package:bingo_game/public/config.dart';
import 'package:equatable/equatable.dart';
import 'package:bingo_game/model/ball.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';

part 'ball_event.dart';
part 'ball_state.dart';

class BallBloc extends Bloc<BallEvent, BallState> {
  final List<Ball> _balls = [];

  BallBloc() : super(BallInitial()) {
    on<AddBall>(_onAddBall);
    on<SaveBall>(_onSaveBall);
    on<RetrieveBall>(_onRetrieveBall);
    on<RetrieveLatestBall>(_onRetrieveLatestBall);
    on<RetrieveRecentBalls>(_onRetrieveRecentBalls);
    on<RetrieveAllBalls>(_onRetrieveAllBalls);
  }

  void _onAddBall(AddBall event, Emitter<BallState> emit) {
    final existingBall =
        _balls.firstWhereOrNull((ball) => ball.id == event.ball.id);
    if (existingBall != null) {
      emit(BallError(message: "Ball with id ${event.ball.id} already exists"));
    } else {
      // Determine the tag based on the number
      String tag;
      if (event.ball.number >= 1 && event.ball.number <= 15) {
        tag = ConfigFactory.tag_yellow;
      } else if (event.ball.number >= 16 && event.ball.number <= 30) {
        tag = ConfigFactory.tag_blue;
      } else if (event.ball.number >= 31 && event.ball.number <= 45) {
        tag = ConfigFactory.tag_red;
      } else if (event.ball.number >= 46 && event.ball.number <= 60) {
        tag = ConfigFactory.tag_purple;
      } else {
        tag = ConfigFactory.tag_green;
      }
      // Proceed to add the new ball
      final ballWithStatus = Ball(
        id: event.ball.id,
        number: event.ball.number,
        tag: tag,
        isCreated: event.ball.isCreated,
        status: "added",
      );
      
      _balls.add(ballWithStatus);
      emit(BallLoaded(ball: ballWithStatus));
    }
  }

  void _onSaveBall(SaveBall event, Emitter<BallState> emit) {
    final index = _balls.indexWhere((ball) => ball.id == event.ball.id);
    if (index != -1) {
      _balls[index] = event.ball;
      emit(BallLoaded(ball: event.ball));
    } else {
      emit(const BallError(message: "Ball not found"));
    }
  }

  void _onRetrieveBall(RetrieveBall event, Emitter<BallState> emit) {
    final ball = _balls.firstWhereOrNull((ball) => ball.id == event.id);
    if (ball != null) {
      emit(BallLoaded(ball: ball));
    } else {
      emit(const BallError(message: "Ball not found"));
    }
  }

  void _onRetrieveLatestBall(
      RetrieveLatestBall event, Emitter<BallState> emit) {
    if (_balls.isNotEmpty) {
      final latestBall = _balls.last;
      emit(BallLoaded(ball: latestBall));
    } else {
      emit(const BallError(message: "Latest ball not found"));
    }
  }

  void _onRetrieveRecentBalls(
      RetrieveRecentBalls event, Emitter<BallState> emit) {
    if (_balls.isNotEmpty) {
      final recentBalls = _balls.take(5).toList();
      emit(BallsLoaded(balls: recentBalls));
    } else {
      emit(const BallError(message: "No recent balls found"));
    }
  }

  void _onRetrieveAllBalls(RetrieveAllBalls event, Emitter<BallState> emit) {
    if (_balls.isNotEmpty) {
      emit(BallsLoaded(balls: _balls));
    } else {
      emit(const BallError(message: "No balls found"));
    }
  }
}
