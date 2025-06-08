import 'package:equatable/equatable.dart';

class CountState extends Equatable {
  final int currentTime;
  final bool isCountRunning;
  final DateTime? startTime;

  const CountState({
    required this.currentTime,
    this.isCountRunning = false,
    this.startTime,
  });

  factory CountState.initial({int currentTime = 0}) => CountState(
    currentTime: currentTime,
    isCountRunning: false,
    startTime: null,
  );

  CountState copyWith({
    int? currentTime,
    bool? isCountRunning,
    DateTime? startTime,
  }) {
    return CountState(
      currentTime: currentTime ?? this.currentTime,
      isCountRunning: isCountRunning ?? this.isCountRunning,
      startTime: startTime ?? this.startTime,
    );
  }

  int get minutes => currentTime ~/ 60;
  int get seconds => currentTime % 60;

  int get hours => currentTime ~/ 3600;
  int get minutesInHour => (currentTime % 3600) ~/ 60;
  int get secondsInMinute => currentTime % 60;

  @override
  List<Object?> get props => [currentTime, isCountRunning, startTime];
}