import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/base_bloc/base.dart';

import '../../data/models/lesson_model.dart';
import '../../data/network/api_constant.dart';
import '../../data/network/api_response.dart';
import '../../data/network/network_impl.dart';
import '../utils.dart';

class LessonInfoCubit extends Cubit<BaseState> {
  LessonInfoCubit() : super(InitState());

  Future<void> lessonInfo(Map<String, dynamic> param) async {
    try {
      emit(LoadingState());

      ApiResponse response = await Network().get(
        url: ApiConstant.lessonInfo,
        params: param,
      );

      if (response.isSuccess) {
        final LessonModel lessonModel = LessonModel.fromJson(response.data);

        emit(LoadedState<LessonModel>(lessonModel));
      } else {
        emit(ErrorState(response.errMessage ?? "Đã có lỗi xảy ra"));
      }
    } catch (e) {
      print(e);
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }
}