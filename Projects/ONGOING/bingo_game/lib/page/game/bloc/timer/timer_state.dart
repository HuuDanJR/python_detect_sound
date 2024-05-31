part of 'timer_bloc.dart';

enum TimerStatus { initial, ticking, finish, failure }

class TimerState extends Equatable {
  final int duration;
  final int tickCount;
  final TimerStatus status;
  final int number;
  final bool isFirstRun;

  const TimerState(
      this.duration, this.tickCount, this.status, this.number, this.isFirstRun);

  factory TimerState.initial({number}) {
    final generatedNumber = number ??
        generateUniqueNumber([],initial: true) ??
        0; // Use the provided number or generate a default one, fallback to 0 if null
    return TimerState(
      TimerBloc._initialDuration,
      0,
      TimerStatus.initial,
      generatedNumber,
      true,
    );
  }

  TimerState copyWith(
      {int? duration,
      int? tickCount,
      TimerStatus? status,
      int? number,
      bool? isFirstRun}) {
    return TimerState(
      duration ?? this.duration,
      tickCount ?? this.tickCount,
      status ?? this.status,
      number ?? this.number,
      isFirstRun ?? this.isFirstRun,
    );
  }

  @override
  String toString() {
    return 'TimerState {duration: $duration, tickCount: $tickCount, status: $status, number: $number, isFirstRun: $isFirstRun}';
  }

  @override
  List<Object?> get props => [duration, tickCount, status, number, isFirstRun];
}
