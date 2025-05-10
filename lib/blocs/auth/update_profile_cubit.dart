import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/base_bloc/base.dart';

import '../../data/network/api_constant.dart';
import '../../data/network/api_response.dart';
import '../../data/network/network_impl.dart';
import '../utils.dart';

class UpdateProfileCubit extends Cubit<BaseState> {
  UpdateProfileCubit() : super(InitState());

  Future<void> updateProfile(Map<String, dynamic> body) async {
    try{
      emit(LoadingState());

      ApiResponse response = await Network().put(url: ApiConstant.updateProfile, body: body);

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
