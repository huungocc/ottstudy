import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/base_bloc/base.dart';

import '../../data/models/registration_model.dart';
import '../../data/network/api_constant.dart';
import '../../data/network/api_response.dart';
import '../../data/network/network_impl.dart';
import '../utils.dart';

class CreateRegistrationCubit extends Cubit<BaseState> {
  CreateRegistrationCubit() : super(InitState());

  Future<void> createRegistration(Map<String, dynamic> body) async {
    try {
      emit(LoadingState());

      ApiResponse response = await Network().post(
        url: ApiConstant.createRegistration,
        body: body,
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