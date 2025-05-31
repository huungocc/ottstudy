import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/base_bloc/base.dart';

import '../../data/models/user_model.dart';
import '../../data/network/api_constant.dart';
import '../../data/network/api_response.dart';
import '../../data/network/network_impl.dart';
import '../utils.dart';

class UserInfoCubit extends Cubit<BaseState> {
  UserInfoCubit() : super(InitState());

  Future<void> getUserInfo(Map<String, dynamic>? param) async {
    try {
      emit(LoadingState());

      ApiResponse response = await Network().get(url: ApiConstant.userInfo, params: param);

      if (response.isSuccess) {
        UserModel userModel = UserModel.fromJson(response.data);
        emit(LoadedState<UserModel>(userModel));
      } else {
        emit(ErrorState(response.errMessage ?? "Đã có lỗi xảy ra"));
      }
    } catch(e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }

  Future<void> getUserInfoByAdmin(Map<String, dynamic>? param) async {
    try {
      emit(LoadingState());

      ApiResponse response = await Network().get(url: ApiConstant.userInfoByAdmin, params: param);

      if (response.isSuccess) {
        UserModel userModel = UserModel.fromJson(response.data);
        emit(LoadedState<UserModel>(userModel));
      } else {
        emit(ErrorState(response.errMessage ?? "Đã có lỗi xảy ra"));
      }
    } catch(e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }
}