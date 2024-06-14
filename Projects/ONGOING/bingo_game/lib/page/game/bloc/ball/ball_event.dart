part of 'ball_bloc.dart';

abstract class BallEvent extends Equatable {
  const BallEvent();

  @override
  List<Object> get props => [];
}

 class AddBall extends BallEvent {
  final Ball ball;
  const AddBall({required this.ball});
  @override
  List<Object> get props => [ball];
}
class SaveBall extends BallEvent {
  final Ball ball;

  const SaveBall({required this.ball});

  @override
  List<Object> get props => [ball];
}
class RetrieveBall extends BallEvent {
  final int id;

  const RetrieveBall({required this.id});

  @override
  List<Object> get props => [id];
}
class RetrieveLatestBall extends BallEvent {
  const RetrieveLatestBall();
} 
class RetrieveRecentBalls extends BallEvent {
  const RetrieveRecentBalls();
}

class RetrieveAllBalls extends BallEvent {
  const RetrieveAllBalls();
}


class InitializeBalls extends BallEvent {
  final List<Ball> initialBalls;
  const InitializeBalls({required this.initialBalls});

  @override
  List<Object> get props => [initialBalls];
}