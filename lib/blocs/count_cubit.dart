import 'dart:async';
import 'package:bloc/bloc.dart';
import 'base_bloc/count_state.dart';

class CountCubit extends Cubit<CountState> {
  Timer? _timer;

  CountCubit({int initialTime = 0}) : super(CountState.initial(currentTime: initialTime));

  void startCount() {
    if (_timer != null) {
      _timer!.cancel();
    }

    emit(state.copyWith(isCountRunning: true));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      emit(state.copyWith(currentTime: state.currentTime + 1));
    });
  }

  void stopCount() {
    _timer?.cancel();
    emit(state.copyWith(isCountRunning: false));
  }

  void resetCount() {
    stopCount();
    emit(state.copyWith(currentTime: 0));
  }

  void pauseCount() {
    _timer?.cancel();
    emit(state.copyWith(isCountRunning: false));
  }

  void resumeCount() {
    if (!state.isCountRunning) {
      startCount();
    }
  }

  void setCurrentTime(int seconds) {
    emit(state.copyWith(currentTime: seconds));
  }

  String getFormattedTime() {
    int minutes = state.currentTime ~/ 60;
    int seconds = state.currentTime % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String getFormattedTimeHMS() {
    int hours = state.currentTime ~/ 3600;
    int minutes = (state.currentTime % 3600) ~/ 60;
    int seconds = state.currentTime % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}