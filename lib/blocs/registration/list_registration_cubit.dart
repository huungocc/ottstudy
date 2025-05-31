import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ottstudy/blocs/base_bloc/base.dart';
import 'package:ottstudy/data/models/registration_model.dart';
import '../../data/network/api_constant.dart';
import '../../data/network/api_response.dart';
import '../../data/network/network_impl.dart';
import '../utils.dart';

class ListRegistrationCubit extends Cubit<BaseState> {
  ListRegistrationCubit() : super(InitState());

  Future<void> getListRegistration(Map<String, dynamic>? param) async {
    try {
      emit(LoadingState());

      ApiResponse response = await Network().get(
        url: ApiConstant.listRegistration,
        params: param,
      );

      if (response.isSuccess) {
        final List<RegistrationModel> registrationModel = (response.data as List)
            .map((item) => RegistrationModel.fromJson(item as Map<String, dynamic>))
            .toList();

        emit(LoadedState<List<RegistrationModel>>(registrationModel));
      } else {
        emit(ErrorState(response.errMessage ?? "Đã có lỗi xảy ra"));
      }
    } catch (e) {
      emit(ErrorState(BlocUtils.getMessageError(e)));
    }
  }
}
