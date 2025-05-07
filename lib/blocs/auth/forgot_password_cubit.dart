import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/base_bloc/base.dart';

import '../../data/network/api_constant.dart';
import '../../data/network/api_response.dart';
import '../../data/network/network_impl.dart';
import '../utils.dart';

class ForgotPasswordCubit extends Cubit<BaseState> {
  ForgotPasswordCubit() : super(InitState());

  Future<void> sendEmail(Map<String, dynamic> body) async {
    try {
      emit(LoadingState());

      ApiResponse response = await Network().post(url: ApiConstant.forgotPassword, body: body);

      if (response.isSuccess) {
        emit(LoadedState<bool>(true));
      } else {
        emit(ErrorState(response.errMessage ?? "Đã có lỗi xảy ra"));
      }
    } catch(e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }

  Future<void> verifyOtp(Map<String, dynamic> body) async {
    try {
      emit(LoadingState());

      ApiResponse response = await Network().post(url: ApiConstant.verifyOtp, body: body);

      if (response.isSuccess) {
        emit(LoadedState<bool>(true));
      } else {
        emit(ErrorState(response.errMessage ?? "Đã có lỗi xảy ra"));
      }
    } catch(e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }
}