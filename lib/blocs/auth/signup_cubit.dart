import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/base_bloc/base.dart';
import 'package:ottstudy/data/models/signup_model.dart';
import 'package:ottstudy/data/network/api_response.dart';
import 'package:ottstudy/data/network/network.dart';

import '../utils.dart';

class SignupCubit extends Cubit<BaseState> {
  SignupCubit() : super(InitState());

  Future<void> doSignup(SignupModel model) async {
    try {
      emit(LoadingState());

      Map<String, dynamic> body = model.toJson();

      ApiResponse response = await Network().post(url: ApiConstant.signup, body: body);

      if (response.isSuccess) {
        emit(LoadedState<bool>(true));
      } else {
        emit(ErrorState(response.errMessage ?? "Đã có lỗi xảy ra"));
      }
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }
}