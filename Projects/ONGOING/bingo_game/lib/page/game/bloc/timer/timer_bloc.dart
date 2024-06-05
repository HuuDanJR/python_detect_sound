import 'dart:async';
import 'package:bingo_game/page/game/left/export.dart';
import 'package:bingo_game/page/game/right/export.dart';
import 'package:bingo_game/page/game/utils.dart';
import 'package:bingo_game/widget/snackbar.custom.dart';
import 'package:bingo_game/widget/text.custom.dart';
import 'package:equatable/equatable.dart';

part 'timer_state.dart';
part 'timer_event.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  static const int _initialDuration =
      ConfigFactory.timer_duration_time; // Initial duration in seconds
  static const int _maxTickCount = ConfigFactory
      .timer_max_round; // Maximum number of times the timer can restart
  Timer? _timer;

  TimerBloc() : super(TimerState.initial()) {
    on<StartTimer>((event, emit) {
      emit(state.copyWith(
          tickCount: state.tickCount,
          number: state.number,
          isFirstRun: state.tickCount == 0 ? true : false));
      _startTimer(event.context);
    });
    on<RestartTimer>((event, emit) {
      emit(
        state.copyWith(
            duration: _initialDuration,
            tickCount: state.tickCount + 1,
            number: state.number,
            isFirstRun: false),
      );
      _startTimer(event.context); // Start the timer again
    });
    on<TickFinished>((event, emit) {});

    on<Tick>((event, emit) {
      if (event.duration > 0) {
        emit(state.copyWith(
          duration: event.duration,
          status: TimerStatus.ticking,
        ));
      } else {
        _timer?.cancel();
        final newNumber = generateUniqueNumber([],initial: true); // Pass an empty set as existingNumbers
        debugPrint('times: ${state.tickCount} => generated number: $newNumber');
        mysnackbarWithContext(
            context: event.context,
            message:"Timer completed, Generated a number $newNumber, times: ${state.tickCount + 1}",
            hasIcon: false);
        //emit ball
        emit(state.copyWith(
            duration: 0, status: TimerStatus.finish, number: newNumber));
        add(const TickFinished()); // Emit TickFinished event
        if (state.tickCount == _maxTickCount) {
          debugPrint('stop timer,end game');
          mysnackbarWithContext(
              context: event.context,
              message: "Game completed ! total times: ${state.tickCount + 1}",
              hasIcon: true);
          // Show dialog
          showDialog(
            context: event.context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: textcustom("Game Finish",const TextStyle(fontWeight: FontWeight.bold)),
                content:textcustom("Bingo Game  has been finished 🎉.\nAll numbers was called.\nTotal times: ${state.tickCount + 1}",const TextStyle(fontWeight: FontWeight.w600)),
                actions: <Widget>[
                  TextButton.icon(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      Navigator.of(context).pop(); // Dismiss the dialog
                    },
                    label: const Text("CANCEL"),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.save_alt),
                    onPressed: () {
                      
                    },
                    label: const Text("SAVE"),
                  ),
                ],
              );
            },
          );
          _timer!.cancel();
        } else {
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
