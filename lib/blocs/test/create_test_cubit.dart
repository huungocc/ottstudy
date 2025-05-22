import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/base_bloc/base.dart';

import '../../data/models/test_model.dart';
import '../../data/network/api_constant.dart';
import '../../data/network/api_response.dart';
import '../../data/network/network_impl.dart';
import '../utils.dart';

class CreateTestCubit extends Cubit<BaseState> {
  CreateTestCubit() : super(InitState());

  Future<void> createTest(Map<String, dynamic>? body) async {
    try {
      emit(LoadingState());

      ApiResponse response = await Network().post(
        url: ApiConstant.createTest,
        body: body,
      );

      if (response.isSuccess) {
        final TestModel lessonModel = TestModel.fromJson(response.data);

        emit(LoadedState<TestModel>(lessonModel));
      } else {
        emit(ErrorState(response.errMessage ?? "Đã có lỗi xảy ra"));
      }
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }

}
