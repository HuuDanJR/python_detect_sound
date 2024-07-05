part of 'timer_bloc.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class InitializeSettings extends TimerEvent {
  const InitializeSettings();

  @override
  List<Object> get props => [];
}

class StartTimer extends TimerEvent {


  const StartTimer();

  @override
  List<Object> get props => [];
}

class Tick extends TimerEvent {
  final int duration;


  const Tick(this.duration, );

  @override
  List<Object> get props => [duration];
}

class SkipTicks extends TimerEvent {
  final int skip;

  const SkipTicks(this.skip);

  @override
  List<Object> get props => [skip];
}



class RestartTimerWithAwait extends TimerEvent {
  final int awaitDuration;

  const RestartTimerWithAwait( this.awaitDuration );

  @override
  List<Object> get props => [ awaitDuration];
}

class RestartTimer extends TimerEvent {

  const RestartTimer();
  @override
  List<Object> get props => [];
}

class PauseTimer extends TimerEvent {
  const PauseTimer();
  @override
  List<Object> get props => [];
}

class ResumeTimer extends TimerEvent {
  const ResumeTimer();
  @override
  List<Object> get props => [];
}

class StopTimer extends TimerEvent {
  const StopTimer();
  @override
  List<Object> get props => [];
}

class TogglePauseResume extends TimerEvent {
  const TogglePauseResume();
  @override
  List<Object> get props => [];
}