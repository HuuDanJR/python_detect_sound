part of 'timer_bloc.dart';

enum TimerStatus { initial, ticking, finish, failure,paused }

class TimerState extends Equatable {
  final int duration;
  final int tickCount;
  final TimerStatus status;
  final int number;
  final bool isFirstRun;
  final int skip;

      
  const TimerState(this.duration, this.tickCount, this.status, this.number, this.isFirstRun,this.skip);

  factory TimerState.initial({number,int skip = 0}) {
    final generatedNumber = number ??
        generateUniqueNumber([],initial: true,) ??
        0; // Use the provided number or generate a default one, fallback to 0 if null
    return TimerState(
      ConfigFactory.timer_duration_time,
      0,
      TimerStatus.initial,
      generatedNumber,
      true,
      // 0, // Initial skip value
      skip
    );
  }

  TimerState copyWith(
      {int? duration,
      int? tickCount,
      TimerStatus? status,
      int? number,
      bool? isFirstRun,
      int? skip}) {
    return TimerState(
      duration ?? this.duration,
      tickCount ?? this.tickCount,
      status ?? this.status,
      number ?? this.number,
      isFirstRun ?? this.isFirstRun,
      skip ?? this.skip,
    );
  }

  @override
  String toString() {
    return 'TimerState {duration: $duration, tickCount: $tickCount, status: $status, number: $number, isFirstRun: $isFirstRun, skip: $skip}';
  }

  @override
  List<Object?> get props => [duration, tickCount, status, number, isFirstRun,skip];
}
