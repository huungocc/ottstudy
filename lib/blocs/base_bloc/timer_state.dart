import 'package:equatable/equatable.dart';

class TimerState extends Equatable {
  final int timeLeft;
  final int totalTime;
  final bool isTimerRunning;
  final bool isTimeUp;

  const TimerState({
    required this.timeLeft,
    required this.totalTime,
    this.isTimerRunning = false,
    this.isTimeUp = false,
  });

  factory TimerState.initial({int totalTime = 0}) => TimerState(
    timeLeft: totalTime,
    totalTime: totalTime,
    isTimerRunning: false,
    isTimeUp: false,
  );

  TimerState copyWith({
    int? timeLeft,
    int? totalTime,
    bool? isTimerRunning,
    bool? isTimeUp,
  }) {
    return TimerState(
      timeLeft: timeLeft ?? this.timeLeft,
      totalTime: totalTime ?? this.totalTime,
      isTimerRunning: isTimerRunning ?? this.isTimerRunning,
      isTimeUp: isTimeUp ?? this.isTimeUp,
    );
  }

  @override
  List<Object> get props => [timeLeft, totalTime, isTimerRunning, isTimeUp];
}