import 'package:bingo_game/hive/hive_controller.dart';
import 'package:bingo_game/hive/model/round_model.dart';
import 'package:bingo_game/page/game/right/export.dart';
import 'package:bingo_game/page/game/utils.dart';
import 'package:bingo_game/public/datetimes.format.dart';
import 'package:equatable/equatable.dart';
import 'package:bingo_game/model/ball.dart';
import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart';

part 'ball_event.dart';
part 'ball_state.dart';

class BallBloc extends Bloc<BallEvent, BallState> {
  final List<Ball> _balls = [];
  final List<Ball> _recentBalls = [];
  final Uuid uuid = const Uuid();
  final format = StringFormat();

  BallBloc() : super(BallInitial(ball: _generateInitialBall())) {
    on<AddBall>(_onAddBall);
    on<RetrieveLatestBall>(_onRetrieveLatestBall);
    on<RetrieveRecentBalls>(_onRetrieveRecentBalls);
    on<RetrieveAllBalls>(_onRetrieveAllBalls);
    on<InitializeBalls>(_onInitializeBalls);

    final initialBall = _generateInitialBall();
    _balls.add(initialBall);
    HiveController().saveNewRound(RoundModel(
        round: [initialBall.number],
        roundId: uuid.v4(),
        createAt: format.formatDateAndTime(DateTime.now())));
    _recentBalls.add(initialBall);
    emit(BallsLoaded(
        balls: List.from(_balls),
        ballsRecent: _recentBalls,
        latestBall:
            initialBall)); // Emit with the initial ball as the latest ball
  }

  void _onAddBall(AddBall event, Emitter<BallState> emit) {
    final existingNumbers = _balls.map((ball) => ball.number).toList();
    final newNumber = generateUniqueNumber(existingNumbers, initial: false);
    final tag = determineTag(newNumber);
    final ballWithStatus = Ball(
      id: event.ball.id,
      number: newNumber,
      tag: tag,
      isCreated: event.ball.isCreated,
      status: "added",
    );
    final existingBall = _balls.firstWhereOrNull((ball) => ball.id == event.ball.id);
    if (existingBall != null) {
      //emit( BallError(message: "Ball with id ${event.ball.id} already exists"));
      return;
    }
    _balls.add(ballWithStatus);
    debugPrint('_onAddBall: ${ballWithStatus.number}');
    HiveController().addToLatestRound([ballWithStatus.number]);
    if (_recentBalls.length < 5) {
      _recentBalls.add(ballWithStatus);
    } else {
      _recentBalls.removeAt(0); // Remove the oldest ball
      _recentBalls.add(ballWithStatus); // Add the new ball
    }
    emit(BallsLoaded(
      balls: List.from(_balls),
      ballsRecent: List.from(_recentBalls),
      latestBall: ballWithStatus,
    ));
  }

  void _onRetrieveLatestBall(
    RetrieveLatestBall event,
    Emitter<BallState> emit,
  ) {
    if (_balls.isNotEmpty) {
      final latestBall = _balls.last;
      emit(BallsLoaded(
          balls: List.from(_balls),
          ballsRecent: List.from(_balls),
          latestBall: latestBall)); // Emit with the latest ball
    } else {
      emit(const BallError(message: "Latest ball not found"));
    }
  }

  void _onRetrieveRecentBalls(
    RetrieveRecentBalls event,
    Emitter<BallState> emit,
  ) {
    if (_balls.isNotEmpty) {
      final recentBalls = _balls.reversed.take(5).toList().reversed.toList();
      emit(BallsLoaded(
        balls: List.from(_balls),
        ballsRecent: recentBalls,
        latestBall: recentBalls.isNotEmpty ? recentBalls.last : _balls.last,
      )); // Emit with the recent balls and latest ball
    } else {
      emit(const BallError(message: "No recent balls found"));
    }
  }

  void _onRetrieveAllBalls(
    RetrieveAllBalls event,
    Emitter<BallState> emit,
  ) {
    if (_balls.isNotEmpty) {
      final recentBalls = _balls.reversed.take(5).toList().reversed.toList();
      emit(BallsLoaded(
        balls: List.from(_balls),
        ballsRecent: recentBalls,
        latestBall: _balls.last,
      )); // Emit with all balls, recent balls, and latest ball
    } else {
      emit(const BallError(message: "No balls found"));
    }
  }

  void _onInitializeBalls(
    InitializeBalls event,
    Emitter<BallState> emit,
  ) {
    _balls.clear();
    _recentBalls.clear();

    _balls.addAll(event.initialBalls);
    

    final initialBall = _generateInitialBallUniqueFromList(event.initialBalls.map((ball) => ball.number).toList());
    _balls.add(initialBall);
    _recentBalls.addAll(event.initialBalls.take(5));


    emit(BallsLoaded(
      balls: List.from(_balls),
      ballsRecent: List.from(_recentBalls),
      latestBall: _balls.last,
    ));
  }

  //generate  a init ball
  static Ball _generateInitialBall() {
    final number = generateUniqueNumber([], initial: false);
    final tag = determineTag(number);
    return Ball(
      id: 0,
      number: number,
      tag: tag,
      isCreated: true,
      status: 'initial',
    );
  }

  //generate  a init ball
  // static Ball _generateInitialBallUniqueFromList(List<int> list) {
  //   final number = generateUniqueNumber(list, initial: true);
  //   final tag = determineTag(number);
  //   return Ball(
  //     id: 0,
  //     number: number,
  //     tag: tag,
  //     isCreated: true,
  //     status: 'initial',
  //   );
  // }
  static Ball _generateInitialBallUniqueFromList(List<int> list) {
    int number;
    do {
      number = generateUniqueNumber(list, initial: false);
    } while (list.contains(number));

    final tag = determineTag(number);
    return Ball(
      id: list.length,
      number: number,
      tag: tag,
      isCreated: true,
      status: 'added',
    );
  }
}

String determineTag(int number) {
  if (number >= 1 && number <= 15) {
    return ConfigFactory.tag_yellow;
  } else if (number >= 16 && number <= 30) {
    return ConfigFactory.tag_blue;
  } else if (number >= 31 && number <= 45) {
    return ConfigFactory.tag_red;
  } else if (number >= 46 && number <= 60) {
    return ConfigFactory.tag_purple;
  } else {
    return ConfigFactory.tag_green;
  }
}
