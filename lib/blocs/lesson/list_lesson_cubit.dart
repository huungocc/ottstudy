import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/base_bloc/base.dart';

import '../../data/models/lesson_model.dart';
import '../../data/network/api_constant.dart';
import '../../data/network/api_response.dart';
import '../../data/network/network_impl.dart';
import '../utils.dart';

class ListLessonCubit extends Cubit<BaseState> {
  ListLessonCubit() : super(InitState());

  Future<void> getListLesson(Map<String, dynamic>? body) async {
    try {
      emit(LoadingState());

      ApiResponse response = await Network().post(
        url: ApiConstant.listLesson,
        body: body,
      );

      if (response.isSuccess) {
        final List<LessonModel> lessonList = (response.data as List)
            .map((item) => LessonModel.fromJson(item as Map<String, dynamic>))
            .toList();

        emit(LoadedState<List<LessonModel>>(lessonList));
      } else {
        emit(ErrorState(response.errMessage ?? "Đã có lỗi xảy ra"));
      }
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }
}
