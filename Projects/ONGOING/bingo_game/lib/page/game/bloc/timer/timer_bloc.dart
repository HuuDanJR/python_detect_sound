import 'dart:async';
import 'package:bingo_game/page/game/utils.dart';
import 'package:bingo_game/public/config.dart';
import 'package:bingo_game/widget/snackbar.custom.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';



part 'timer_state.dart';
part 'timer_event.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  static const int _initialDuration = ConfigFactory.timer_duration_time; // Initial duration in seconds
  static const int _maxTickCount = ConfigFactory.timer_max_round; // Maximum number of times the timer can restart
  Timer? _timer;

  TimerBloc() : super(TimerState.initial()) {
    on<StartTimer>((event, emit) {
      emit(state.copyWith(tickCount: state.tickCount ,number: state.number,isFirstRun: state.tickCount == 0 ? true : false));
      _startTimer(event.context);
    });
    on<RestartTimer>((event, emit) {
      emit(state.copyWith(duration: _initialDuration, tickCount: state.tickCount + 1,number: state.number,isFirstRun: false),);
      _startTimer(event.context); // Start the timer again
    });
    on<TickFinished>((event, emit) {
      
    });

    on<Tick>((event, emit) {
      if (event.duration > 0) {
         emit(state.copyWith(duration: event.duration,status: TimerStatus.ticking,));
      } else {
        _timer?.cancel();
        final newNumber = generateUniqueNumber([],initial: true); // Pass an empty set as existingNumbers
        debugPrint('times: ${state.tickCount} generated number $newNumber');
        mysnackbarWithContext(context: event.context, message: "Timer completed, Generated a number $newNumber, times: ${state.tickCount+1}",hasIcon: false);
        //emit ball 
        emit(state.copyWith(duration: 0,status: TimerStatus.finish,number: newNumber));
        add(const TickFinished()); // Emit TickFinished event
        if (state.tickCount == _maxTickCount) {
          debugPrint('stop timer,end game');
          mysnackbarWithContext(context: event.context, message: "Game completed ! total times: ${state.tickCount+1}",hasIcon: true);
          _timer!.cancel();
        }else {
          add(RestartTimer(event.context));
        }
      }
    });
  }

  void _startTimer(BuildContext context) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final newDuration = state.duration - 1;
      add(Tick(newDuration, context));
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
