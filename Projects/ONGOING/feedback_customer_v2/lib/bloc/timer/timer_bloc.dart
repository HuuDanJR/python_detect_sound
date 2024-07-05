import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:feedback_customer/util/string_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'timer_state.dart';
part 'timer_event.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  static const int _maxTickCount = 0; // Maximum number of times the timer can restart
  Timer? _timer;

  TimerBloc() : super(TimerState.initial()) {
    on<StartTimer>((event, emit) {
      emit(state.copyWith(
          tickCount: state.tickCount,
          isFirstRun: true,
          status: TimerStatus.initial));
      _startTimer();
      // _awaitBeforeStart(event.context, event.awaitDuration);
    });

    on<TogglePauseResume>((event, emit) {
      if (state.status == TimerStatus.ticking) {
        _timer?.cancel();
        emit(state.copyWith(status: TimerStatus.paused));
      } else if (state.status == TimerStatus.paused) {
        _startTimer();
        emit(state.copyWith(status: TimerStatus.ticking));
      }
    });

    on<StopTimer>((event, emit) {
      _timer?.cancel();
      emit(state.copyWith(status: TimerStatus.finish));
    });

    on<RestartTimerWithAwait>(_onRestartTimerWithAwait);

    on<Tick>((event, emit) {
      if (event.duration > 0) {
        emit(state.copyWith(
          duration: event.duration,
          status: TimerStatus.ticking,
        ));
      } else {
        _timer?.cancel();
        debugPrint('times: ${state.tickCount + 1} ');
        emit(state.copyWith(
          duration: 0,
          status: TimerStatus.finish,
        ));
        if (state.tickCount == _maxTickCount) {
          debugPrint('stop timer, end game');
          _timer!.cancel();
        } else {
          add(const RestartTimer());
        }
      }
    });
  }

  // void _awaitBeforeStart(BuildContext context, int awaitDuration) {
  //   Future.delayed(Duration(seconds: awaitDuration), () {
  //     if (state.status == TimerStatus.initial) {
  //       emit(state.copyWith(status: TimerStatus.await));
  //       _startTimer(context);
  //     }
  //   });
  // }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final newDuration = state.duration - 1;
      add(Tick(newDuration));
    });
  }

  void _onRestartTimerWithAwait(
      RestartTimerWithAwait event, Emitter<TimerState> emit) {
    _timer?.cancel();
    emit(state.copyWith(
        duration: StringFactory.durationTimer,
        status: TimerStatus.initial,
        tickCount: 0));
    Future.delayed(Duration(seconds: event.awaitDuration), () {
      add(const StartTimer(
        
      ));
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
