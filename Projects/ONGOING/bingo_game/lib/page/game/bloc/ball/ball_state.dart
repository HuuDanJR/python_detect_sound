part of 'ball_bloc.dart';

abstract class BallState extends Equatable {
  const BallState();
  @override
  List<Object> get props => [];
}

class BallInitial extends BallState {
  final Ball ball;
  const BallInitial({required this.ball});

  @override
  List<Object> get props => [ball];
}

class BallLoading extends BallState {}

//state all balls
class BallsLoaded extends BallState {
  final List<Ball> balls;
  final List<Ball> ballsRecent;
  final Ball latestBall;
  const BallsLoaded({required this.balls, required this.latestBall,required this.ballsRecent});
  @override
  List<Object> get props => [balls, latestBall,ballsRecent];
}

class BallError extends BallState {
  final String message;
  const BallError({required this.message});
  @override
  List<Object> get props => [message];
}
