import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/base_bloc/base.dart';

import '../../data/models/course_model.dart';
import '../../data/network/api_constant.dart';
import '../../data/network/api_response.dart';
import '../../data/network/network_impl.dart';
import '../utils.dart';

class MyRegistrationCubit extends Cubit<BaseState> {
  MyRegistrationCubit() : super(InitState());

  Future<void> getMyRegistration(Map<String, dynamic>? params) async {
    try {
      emit(LoadingState());

      ApiResponse response = await Network().get(
        url: ApiConstant.myListRegistration,
        params: params,
      );

      if (response.isSuccess) {
        final List<CourseModel> courseList = (response.data as List)
            .map((item) => CourseModel.fromJson(item as Map<String, dynamic>))
            .toList();

        emit(LoadedState<List<CourseModel>>(courseList));
      } else {
        emit(ErrorState(response.errMessage ?? "Đã có lỗi xảy ra"));
      }
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }
}
