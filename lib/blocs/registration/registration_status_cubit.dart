import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/base_bloc/base.dart';

import '../../data/models/registration_model.dart';
import '../../data/network/api_constant.dart';
import '../../data/network/api_response.dart';
import '../../data/network/network_impl.dart';
import '../utils.dart';

class RegistrationStatusCubit extends Cubit<BaseState> {
  RegistrationStatusCubit() : super(InitState());

  Future<void> getRegistrationStatus(Map<String, dynamic> param) async {
    try {
      emit(LoadingState());

      ApiResponse response = await Network().get(
        url: ApiConstant.registrationStatus,
        params: param,
      );

      if (response.isSuccess) {
        final RegistrationModel registrationModel = RegistrationModel.fromJson(response.data);

        emit(LoadedState<RegistrationModel>(registrationModel));
      } else {
        emit(ErrorState(response.errMessage ?? "Đã có lỗi xảy ra"));
      }
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }
}