import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/base_bloc/base.dart';
import 'package:ottstudy/data/models/forgot_password_model.dart';

import '../../data/network/api_constant.dart';
import '../../data/network/api_response.dart';
import '../../data/network/network_impl.dart';
import '../utils.dart';

class VerifyOtpCubit extends Cubit<BaseState> {
  VerifyOtpCubit() : super(InitState());

  Future<void> verifyOtp(Map<String, dynamic> body) async {
    try {
      emit(LoadingState());

      ApiResponse response = await Network().post(url: ApiConstant.verifyOtp, body: body);

      if (response.isSuccess) {
        ForgotPasswordModel forgotPasswordModel = ForgotPasswordModel.fromJson(response.data);
        emit(LoadedState<ForgotPasswordModel>(forgotPasswordModel));
      } else {
        emit(ErrorState(response.errMessage ?? "Đã có lỗi xảy ra"));
      }
    } catch(e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }
}