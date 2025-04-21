// essay_cubit.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'base_bloc/timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  Timer? _timer;

  TimerCubit({int initialTime = 0}) : super(TimerState.initial(totalTime: initialTime));

  void startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }

    emit(state.copyWith(isTimerRunning: true, isTimeUp: false));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeLeft > 0) {
        emit(state.copyWith(timeLeft: state.timeLeft - 1));
      } else {
        emit(state.copyWith(isTimerRunning: false, isTimeUp: true));
        stopTimer();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    emit(state.copyWith(isTimerRunning: false));
  }

  void resetTimer() {
    stopTimer();
    emit(state.copyWith(timeLeft: state.totalTime, isTimeUp: false));
  }

  void setTotalTime(int seconds) {
    emit(state.copyWith(totalTime: seconds, timeLeft: seconds, isTimeUp: false));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}