import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/base_bloc/base.dart';

import '../../data/models/course_model.dart';
import '../../data/network/api_constant.dart';
import '../../data/network/api_response.dart';
import '../../data/network/network_impl.dart';
import '../utils.dart';

class CreateCourseCubit extends Cubit<BaseState> {
  CreateCourseCubit() : super(InitState());

  Future<void> createCourse(Map<String, dynamic>? body) async {
    try {
      emit(LoadingState());

      ApiResponse response = await Network().post(
        url: ApiConstant.createCourse,
        body: body,
      );

      if (response.isSuccess) {
        final CourseModel courseModel = CourseModel.fromJson(response.data);

        emit(LoadedState<CourseModel>(courseModel));
      } else {
        emit(ErrorState(response.errMessage ?? "Đã có lỗi xảy ra"));
      }
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }
}
