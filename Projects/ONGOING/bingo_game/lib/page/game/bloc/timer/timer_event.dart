part of 'timer_bloc.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class StartTimer extends TimerEvent {
  final BuildContext context;

  const StartTimer(this.context);

  @override
  List<Object> get props => [context];
}

class Tick extends TimerEvent {
  final int duration;
  final BuildContext context;

  const Tick(this.duration, this.context);

  @override
  List<Object> get props => [duration, context];
}



//skip tick count when initialize a ball list
class SkipTicks extends TimerEvent {
  final int skip;

  const SkipTicks(this.skip);

  @override
  List<Object> get props => [skip];
}


//check whether timer is finish
class TickFinished extends TimerEvent {
  const TickFinished();
  @override
  List<Object> get props => [];
}



class RestartTimer extends TimerEvent {
  final BuildContext context;
  const RestartTimer(this.context);
  @override
  List<Object> get props => [context];
}












// class PauseTimer extends TimerEvent {
//   final BuildContext context;
//   const PauseTimer(this.context);
//   @override
//   List<Object> get props => [context];
// }
// class ResumeTimer extends TimerEvent {
//   final BuildContext context;
//   const ResumeTimer(this.context);
//   @override
//   List<Object> get props => [context];
// }

// class ResetTimer extends TimerEvent {
//   final BuildContext context;
//   const ResetTimer(this.context);
//   @override
//   List<Object> get props => [context];
// }