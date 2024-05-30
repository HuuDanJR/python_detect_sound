part of 'ball_bloc.dart';


abstract class BallState extends Equatable {
  const BallState();
  @override
  List<Object> get props => [];
}

class BallInitial extends BallState {}


class BallLoading extends BallState {}


class BallLoaded extends BallState {
  final Ball ball;
  const BallLoaded({required this.ball});
  @override
  List<Object> get props => [ball];
}

class BallsLoaded extends BallState {
  final List<Ball> balls;
  const BallsLoaded({required this.balls});
  @override
  List<Object> get props => [balls];
}

class BallError extends BallState {
  final String message;
  const BallError({required this.message});
  @override
  List<Object> get props => [message];
}