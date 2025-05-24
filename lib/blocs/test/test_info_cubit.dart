import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/base_bloc/base.dart';

import '../../data/models/test_model.dart';
import '../../data/network/api_constant.dart';
import '../../data/network/api_response.dart';
import '../../data/network/network_impl.dart';
import '../utils.dart';

class TestInfoCubit extends Cubit<BaseState> {
  TestInfoCubit() : super(InitState());

  Future<void> testInfo(Map<String, dynamic> param) async {
    try {
      emit(LoadingState());

      ApiResponse response = await Network().get(
        url: ApiConstant.testInfo,
        params: param,
      );

      if (response.isSuccess) {
        final TestModel testModel = TestModel.fromJson(response.data);

        emit(LoadedState<TestModel>(testModel));
      } else {
        emit(ErrorState(response.errMessage ?? "Đã có lỗi xảy ra"));
      }
    } catch (e) {
      print(e);
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }
}