import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/base_bloc/base.dart';
import 'package:ottstudy/data/models/lesson_model.dart';

import '../../data/network/api_constant.dart';
import '../../data/network/api_response.dart';
import '../../data/network/network_impl.dart';
import '../utils.dart';

class CreateLessonCubit extends Cubit<BaseState> {
  CreateLessonCubit() : super(InitState());

  Future<void> createLesson(Map<String, dynamic>? body) async {
    try {
      emit(LoadingState());

      ApiResponse response = await Network().post(
        url: ApiConstant.createLesson,
        body: body,
      );

      if (response.isSuccess) {
        final LessonModel lessonModel = LessonModel.fromJson(response.data);

        emit(LoadedState<LessonModel>(lessonModel));
      } else {
        emit(ErrorState(response.errMessage ?? "Đã có lỗi xảy ra"));
      }
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }
}
