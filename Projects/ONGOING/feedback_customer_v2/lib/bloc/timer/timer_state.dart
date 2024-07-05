part of 'timer_bloc.dart';

enum TimerStatus { initial, ticking, finish, failure, paused, }



class TimerState extends Equatable {
  final int duration;
  final int tickCount;
  final TimerStatus status;
  final bool isFirstRun;

  const TimerState(this.duration, this.tickCount, this.status, this.isFirstRun);

  factory TimerState.initial() {
    return const TimerState(
        StringFactory.durationTimer,
        0,
        TimerStatus.initial,
        true,
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
      isFirstRun??this.isFirstRun
    );
  }

  @override
  String toString() {
    return 'TimerState {duration: $duration, tickCount: $tickCount, status: $status}';
  }

  @override
  List<Object?> get props =>
      [duration, tickCount, status, isFirstRun];
}
